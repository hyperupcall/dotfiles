#!/usr/bin/env python3
"""Transfer data between machines via an encrypted removable drive.

Python rewrite of ``transfer-data.sh``. It saves selected files and
directories to a removable drive (encrypting the sensitive ones with a
password) and restores them on another machine.
"""

import json
import os
import re
import secrets
import shutil
import string
import subprocess
import sys
import tempfile
import termios
from contextlib import contextmanager
from pathlib import Path

DOTFILES_DIR = Path.home() / '.dotfiles'
SETUP_SH = DOTFILES_DIR / 'config' / 'setup.sh'
SETUP_PRIVATE_SH = DOTFILES_DIR / 'config' / 'setup-private.sh'
BOOTSTRAP_SH = DOTFILES_DIR / 'bootstrap-linux.sh'


def _should_print_color(fd: int) -> bool:
	if 'NO_COLOR' in os.environ:
		return False

	force_color = os.environ.get('FORCE_COLOR')
	if force_color in ('1', '2', '3'):
		return True
	if force_color == '0':
		return False

	if os.environ.get('TERM') == 'dumb':
		return False

	return os.isatty(fd)


def print_info(msg: str) -> None:
	if _should_print_color(1):
		print(f'\033[1;32mInfo:\033[0m {msg}')
	else:
		print(f'Info: {msg}')


def print_warn(msg: str) -> None:
	if _should_print_color(2):
		print(f'\033[1;33mWarn:\033[0m {msg}', file=sys.stderr)
	else:
		print(f'Warn: {msg}', file=sys.stderr)


def print_fatal(msg: str) -> None:
	if _should_print_color(2):
		print(f'\033[1;35mFatal:\033[0m {msg}', file=sys.stderr)
	else:
		print(f'Fatal: {msg}', file=sys.stderr)


def die(msg: str) -> None:
	print_fatal(msg)
	sys.exit(1)


def prompt_one_char(prompt_text: str) -> str:
	"""Read a single character without requiring the user to press Enter.

	Mirrors the behavior of bash's ``read -N1``: the character is echoed and
	a newline is printed afterwards.
	"""
	sys.stdout.write(prompt_text)
	sys.stdout.flush()

	if not sys.stdin.isatty():
		char = sys.stdin.read(1)
		sys.stdout.write('\n')
		return char

	fd = sys.stdin.fileno()
	old_attrs = termios.tcgetattr(fd)
	new_attrs = termios.tcgetattr(fd)
	# Disable canonical mode but keep echo enabled.
	new_attrs[3] &= ~termios.ICANON
	new_attrs[6][termios.VMIN] = 1
	new_attrs[6][termios.VTIME] = 0
	try:
		termios.tcsetattr(fd, termios.TCSADRAIN, new_attrs)
		char = sys.stdin.read(1)
	finally:
		termios.tcsetattr(fd, termios.TCSADRAIN, old_attrs)

	sys.stdout.write('\n')
	return char


def prompt_yes_no(prompt_text: str) -> bool:
	return prompt_one_char(prompt_text).lower() == 'y'


def remove_trailing_slash(path: str) -> str:
	return path.removesuffix('/')


def remove_last_component(path: str) -> str:
	return path.rsplit('/', 1)[0] if '/' in path else path


def load_xdg_dirs() -> tuple[str, str, str]:
	"""Source ``setup.sh`` and read the XDG base directory variables."""
	script = (
		f'source {SETUP_SH} >/dev/null 2>&1; '
		'printf "%s\\n" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"'
	)
	result = subprocess.run(
		['bash', '-c', script],
		capture_output=True,
		text=True,
		check=False,
	)

	lines = result.stdout.splitlines()
	if len(lines) >= 3 and all(lines[:3]):
		return lines[0], lines[1], lines[2]

	return (
		os.environ.get('XDG_CONFIG_HOME', ''),
		os.environ.get('XDG_DATA_HOME', ''),
		os.environ.get('XDG_STATE_HOME', ''),
	)


def list_mount_options() -> list[str]:
	"""Print candidate mount points and return them in order."""
	result = subprocess.run(
		[
			'lsblk',
			'--list',
			'--json',
			'--output',
			'ID,FSSIZE,FSTYPE,MODEL,PATH,NAME,LABEL,MOUNTPOINT',
		],
		capture_output=True,
		text=True,
		check=True,
	)
	data = json.loads(result.stdout)

	devices = [
		device
		for device in data.get('blockdevices', [])
		if device.get('mountpoint') is not None
		and re.search(r'^/mnt|/media|/run', device['mountpoint'])
	]

	options: list[str] = []
	for index, device in enumerate(devices):
		mountpoint = device['mountpoint']
		device_id = (device.get('id') or '')[:50]
		path = device.get('path')
		fssize = device.get('fssize')
		fstype = device.get('fstype')
		print(
			f'#{index}\n'
			f'  ID: {device_id}...\n'
			f'  MOUNTPOINT: {mountpoint} ({path})\n'
			f'  SIZE: {fssize} ({fstype})'
		)
		options.append(mountpoint)

	return options


@contextmanager
def _passphrase_fd(password: str):
	"""Yield a file descriptor that gpg can read the passphrase from."""
	read_fd, write_fd = os.pipe()
	os.write(write_fd, password.encode() + b'\n')
	os.close(write_fd)
	try:
		yield read_fd
	finally:
		os.close(read_fd)


def _gpg_args(homedir: str, passphrase_fd: int) -> list[str]:
	return [
		'gpg',
		'--homedir',
		homedir,
		'--no-keyring',
		'--batch',
		'--yes',
		'--pinentry-mode',
		'loopback',
		'--passphrase-fd',
		str(passphrase_fd),
		'--cipher-algo',
		'AES256',
		'--no-symkey-cache',
		'--armor',
	]


def encrypt_dir(src_dir: str, dest_file: str, password: str, homedir: str) -> None:
	parent = os.path.dirname(src_dir)
	basename = os.path.basename(src_dir)

	with _passphrase_fd(password) as passphrase_fd, open(dest_file, 'wb') as out:
		tar_proc = subprocess.Popen(
			['tar', '-C', parent, '-c', f'./{basename}'],
			stdout=subprocess.PIPE,
		)
		gpg_proc = subprocess.Popen(
			[*_gpg_args(homedir, passphrase_fd), '--symmetric'],
			stdin=tar_proc.stdout,
			stdout=out,
			pass_fds=(passphrase_fd,),
		)
		tar_proc.stdout.close()
		gpg_proc.wait()
		tar_proc.wait()

	if gpg_proc.returncode != 0:
		print_warn(f'gpg failed with exit code {gpg_proc.returncode}')
	if tar_proc.returncode != 0:
		print_warn(f'tar failed with exit code {tar_proc.returncode}')


def decrypt_to_dir(src_file: str, dest_dir: str, password: str, homedir: str) -> None:
	parent = os.path.dirname(dest_dir)

	with _passphrase_fd(password) as passphrase_fd, open(src_file, 'rb') as inp:
		gpg_proc = subprocess.Popen(
			[*_gpg_args(homedir, passphrase_fd), '--decrypt'],
			stdin=inp,
			stdout=subprocess.PIPE,
			pass_fds=(passphrase_fd,),
		)
		tar_proc = subprocess.Popen(
			['tar', '-C', parent, '-x'],
			stdin=gpg_proc.stdout,
		)
		gpg_proc.stdout.close()
		tar_proc.wait()
		gpg_proc.wait()

	if gpg_proc.returncode != 0:
		print_warn(f'gpg failed with exit code {gpg_proc.returncode}')
	if tar_proc.returncode != 0:
		print_warn(f'tar failed with exit code {tar_proc.returncode}')


def decrypt_setup_private(
	src_file: str, dest_file: str, password: str, homedir: str
) -> None:
	with _passphrase_fd(password) as passphrase_fd:
		gpg_proc = subprocess.Popen(
			[*_gpg_args(homedir, passphrase_fd), '--decrypt', src_file],
			stdout=subprocess.PIPE,
			pass_fds=(passphrase_fd,),
		)
		with open(dest_file, 'wb') as out:
			tar_proc = subprocess.Popen(
				['tar', '-xO'],
				stdin=gpg_proc.stdout,
				stdout=out,
			)
			gpg_proc.stdout.close()
			tar_proc.wait()
			gpg_proc.wait()

	if gpg_proc.returncode != 0:
		print_warn(f'gpg failed with exit code {gpg_proc.returncode}')
	if tar_proc.returncode != 0:
		print_warn(f'tar failed with exit code {tar_proc.returncode}')


def remove_broken_symlinks(directory: str) -> None:
	"""Remove top-level broken symlinks, which cannot be copied over."""
	for entry in Path(directory).iterdir():
		# Bash globs do not match dotfiles.
		if entry.name.startswith('.'):
			continue
		if entry.is_symlink() and not entry.exists():
			entry.unlink()


def save(dirpath: str, paths_encrypt: dict[str, str], paths: dict[str, str]) -> None:
	subprocess.run(['sudo', 'rm', '-rf', dirpath], check=True)
	subprocess.run(['sudo', 'mkdir', '-p', dirpath], check=True)
	user = os.environ.get('USER', '')
	subprocess.run(['sudo', 'chown', f'{user}:{user}', dirpath], check=True)

	shutil.copyfile(Path(__file__).resolve(), Path(dirpath) / 'transfer-data.py')
	shutil.copyfile(BOOTSTRAP_SH, Path(dirpath) / 'bootstrap.sh')
	os.chmod(Path(dirpath) / 'transfer-data.py', 0o755)
	os.chmod(Path(dirpath) / 'bootstrap.sh', 0o755)

	alphabet = string.ascii_letters + string.digits + string.punctuation
	password = ''.join(secrets.choice(alphabet) for _ in range(14))
	temp_gnupg = tempfile.mkdtemp(suffix='-gnupg')
	print_info(f'Password: {password}')

	if prompt_yes_no('Save password to _data/pw.txt? [y/n] '):
		Path(dirpath).mkdir(parents=True, exist_ok=True)
		(Path(dirpath) / 'pw.txt').write_text(f'{password}\n')
		print_info(f'Password written to {dirpath}/pw.txt')

	for name, directory in paths_encrypt.items():
		encrypted_file = f'{dirpath}/{name}.tar.gz.asc'

		if not directory or not os.path.exists(directory):
			print_warn(f"Skipping {name}: '{directory}' does not exist")
			continue

		print_info(f'Encrypting {directory} to {encrypted_file}')
		Path(encrypted_file).parent.mkdir(parents=True, exist_ok=True)
		encrypt_dir(directory, encrypted_file, password, temp_gnupg)

	for name, directory in paths.items():
		src = f'{dirpath}/{name}.tar.gz'

		if not directory or not os.path.exists(directory):
			print_warn(f"Skipping {name}: '{directory}' does not exist")
			continue

		print_info(f'Copying {directory} to {src}')
		Path(src).parent.mkdir(parents=True, exist_ok=True)
		# The directory may contain symlinks, so copy as tarball so it is always
		# preserved, no matter the file system.
		subprocess.run(['tar', '-C', directory, '-cf', src, '.'], check=True)


def restore(dirpath: str, paths_encrypt: dict[str, str], paths: dict[str, str]) -> None:
	pw_file = Path(dirpath) / 'pw.txt'
	if pw_file.is_file():
		password = pw_file.read_text().rstrip('\n')
		print_info(f'Using password from {pw_file}')
	else:
		password = input('Password? ')

	temp_gnupg = tempfile.mkdtemp(suffix='-gnupg')

	for name, directory in paths_encrypt.items():
		encrypted_file = f'{dirpath}/{name}.tar.gz.asc'

		# Mirrors the original check, which is currently a no-op.
		if directory == 'scripts_hidden':
			continue

		if os.path.exists(directory):
			print_warn(f'File or directory {directory} already exists')
			if prompt_yes_no('Remove? [y/n] '):
				subprocess.run(['rm', '-rf', directory], check=True)
			else:
				print_warn(f'Skipping directory {directory}')
				continue
		elif not prompt_yes_no(f'Copy to {directory}? [y/n] '):
			print_warn(f'Skipping directory {directory}')
			continue

		print_info(f'Decrypting {encrypted_file} to {directory}')
		Path(directory).parent.mkdir(parents=True, exist_ok=True)
		decrypt_to_dir(encrypted_file, directory, password, temp_gnupg)

		if os.path.isdir(directory):
			remove_broken_symlinks(directory)

	for name, directory in paths.items():
		src = f'{dirpath}/{name}.tar.gz'

		if os.path.exists(directory):
			print_warn(f'File or directory {directory} already exists')
			if prompt_yes_no('Remove? [y/n] '):
				subprocess.run(['rm', '-rf', directory], check=True)
			else:
				print_warn(f'Skipping directory {directory}')
				continue
		elif not prompt_yes_no(f'Copy to {directory}? [y/n] '):
			print_warn(f'Skipping directory {directory}')
			continue

		print_info(f'Extracting {src} to {directory}')
		Path(directory).mkdir(parents=True, exist_ok=True)
		# The directory may contain symlinks, so copy as tarball so it is always
		# preserved, no matter the file system.
		subprocess.run(['tar', '-C', directory, '-xf', src], check=True)


def main() -> None:
	home = str(Path.home())
	xdg_config_home, xdg_data_home, xdg_state_home = load_xdg_dirs()

	while True:
		mode = input('Which mode? (save|restore): ')
		if mode in ('save', 'restore'):
			break

	options = list_mount_options()
	options.append('__manual__')
	print(f'#{len(options) - 1}\n  MOUNTPOINT: (specify manually)')

	while True:
		answer = input('Choose location for temporary files: ')
		if re.fullmatch(r'[0-9]+', answer) and 0 <= int(answer) < len(options):
			break

	device_path = options[int(answer)]
	if device_path == '__manual__':
		device_path = input('Enter directory path: ')

	dirpath = f'{remove_trailing_slash(device_path)}/_data'

	if not SETUP_PRIVATE_SH.is_file():
		temp_gnupg_dir = tempfile.mkdtemp(suffix='-gnupg')
		password = (Path(dirpath) / 'pw.txt').read_text().rstrip('\n')
		decrypt_setup_private(
			f'{dirpath}/setup_private_sh.tar.gz.asc',
			str(SETUP_PRIVATE_SH),
			password,
			temp_gnupg_dir,
		)
	# The original sources setup-private.sh here. Its variables are not used by
	# the active code, so there is nothing to load.

	paths_encrypt = {
		'gnupg': f'{home}/.gnupg',
		'ssh': f'{home}/.ssh',
		'history': f'{xdg_state_home}/history',
		'syncthing': f'{xdg_state_home}/syncthing',
		'borgkeys': f'{xdg_config_home}/borg/keys',
		'basalt_token': f'{xdg_config_home}/basalt/token',
		'woof_token': f'{xdg_data_home}/woof/token',
		# 'scripts_hidden': _private_scripts_hidden,
		'setup_private_exec_sh': f'{home}/.dotfiles/config/setup-private-exec.sh',
		'setup_private_py': f'{home}/.dotfiles/config/setup-private.py',
		'setup_private_sh': f'{home}/.dotfiles/config/setup-private.sh',
		'dotfiles_git_exclude': f'{home}/.dotfiles/.git/info/exclude',
	}
	paths = {
		'libreoffice': f'{xdg_config_home}/libreoffice/4/user',
		'fonts': f'{xdg_data_home}/fonts',
		'dbeaver': f'{xdg_data_home}/DBeaverData/workspace6/General/Scripts',
		'ankiuserdata': f'{xdg_data_home}/Anki2/Default User',
		'ankiaddons': f'{xdg_data_home}/Anki2/addons21',
		'applicationsdir': f'{home}/Other/Application Data',
		'devresources': f'{home}/.devhidden',
	}

	if mode == 'save':
		save(dirpath, paths_encrypt, paths)
	elif mode == 'restore':
		restore(dirpath, paths_encrypt, paths)
	else:
		die(f'Invalid mode: {mode}')

	if prompt_yes_no(
		f'Done! Would you like to unmount {remove_last_component(dirpath)}? '
	):
		os.chdir(Path.home())
		subprocess.run(['sudo', 'umount', remove_last_component(dirpath)], check=False)

	print_info('Exiting.')


if __name__ == '__main__':
	try:
		main()
	except KeyboardInterrupt:
		print()
		sys.exit(130)
	except subprocess.CalledProcessError as exc:
		die(f'Command failed with exit code {exc.returncode}: {exc.cmd}')
