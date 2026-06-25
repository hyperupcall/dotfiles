#!/usr/bin/env python3
import json
import os
import re
import subprocess
import sys
from pathlib import Path


def fix_adjacent_symlink(gpg_path: Path) -> bool:
	symlink_content = gpg_path.read_text()
	maybe_file = gpg_path.parent / symlink_content
	if maybe_file.is_file():
		print(
			f'File "{gpg_path}" is supposed to be a symlink to '
			f'"{symlink_content}". Replacing.'
		)
		gpg_path.unlink()
		gpg_path.symlink_to(symlink_content)
		return True
	return False


def load_ignore_list(pass_store_dir: str) -> list[str]:
	config_file = Path(pass_store_dir) / 'config.json'
	if not config_file.is_file():
		raise SystemExit(f'ERROR: Config file not found at {config_file}\n')

	try:
		config = json.loads(config_file.read_text())
	except json.JSONDecodeError as exc:
		raise SystemExit(f'ERROR: Failed to parse {config_file}: {exc}\n') from exc

	ignore_logins = config.get('ignore_logins')
	if not isinstance(ignore_logins, list):
		raise SystemExit(
			f"ERROR: {config_file} does not contain an 'ignore_logins' array\n"
		)
	return ignore_logins


def iter_gpg_files(root: Path):
	for dirpath, dirnames, filenames in os.walk(root):
		dirnames[:] = [name for name in dirnames if name != '.git']
		for filename in filenames:
			if filename.endswith('.gpg'):
				yield Path(dirpath) / filename


def resolve_symlink_target(content: str, pass_store_dir: str) -> str | None:
	if content.startswith('/'):
		if content == pass_store_dir:
			return '.'
		prefix = f'{pass_store_dir}/'
		if content.startswith(prefix):
			return content[len(prefix) :]
		return None
	return content


def fix_symlinks_interactive(pass_store_dir: str) -> None:
	root = Path(pass_store_dir)

	for gpg_path in iter_gpg_files(root):
		file_output = subprocess.run(
			['file', str(gpg_path)],
			capture_output=True,
			text=True,
			check=False,
		).stdout

		if 'ASCII text' not in file_output:
			continue

		try:
			content = gpg_path.read_text(encoding='utf-8').rstrip('\n')
		except OSError as exc:
			print(
				f"Could not open '{gpg_path}' for reading: {exc}",
				file=sys.stderr,
			)
			continue

		target_link_path = resolve_symlink_target(content, pass_store_dir)
		if target_link_path is None:
			print(
				f"Content '{content}' is an absolute path but not within or equal "
				f"to PASSWORD_STORE_DIR '{pass_store_dir}'. Skipping '{gpg_path}'.",
				file=sys.stderr,
			)
			continue

		print(f'removing {gpg_path}')
		user_input = input(
			f'Remove {gpg_path} for symlink to {target_link_path}? [y/n]? '
		).strip()
		if user_input.lower() != 'y':
			continue

		try:
			gpg_path.unlink()
			gpg_path.symlink_to(target_link_path)
			print(f'Symlink created at {gpg_path}, to {target_link_path}')
		except OSError as exc:
			print(f"Failed to fix symlink for '{gpg_path}': {exc}", file=sys.stderr)


def lint_password_store(
	password_store_dir: Path, ignore_list: list[str]
) -> tuple[int, dict[str, int], dict[str, int]]:
	total_passwords = 0
	property_counts: dict[str, int] = {}
	email_counts: dict[str, int] = {}
	store_root = password_store_dir.resolve()

	for gpg_path in iter_gpg_files(password_store_dir):
		total_passwords += 1
		pass_name = (
			gpg_path.resolve().with_suffix('').relative_to(store_root).as_posix()
		)

		result = subprocess.run(
			['pass', 'show', pass_name],
			capture_output=True,
			text=True,
			check=False,
		)
		pass_content = result.stdout + result.stderr

		if 'gpg: decryption failed: No secret key' in pass_content:
			print(f'No secret key found for file: "{gpg_path}"')
			continue

		if 'gpg: no valid OpenPGP data found' in pass_content:
			if fix_adjacent_symlink(gpg_path):
				continue
			print(f'No valid GPG data found: "{gpg_path}"', file=sys.stderr)
			continue

		pass_content = re.sub(r'[ \t]+', ' ', pass_content)
		filtered_pass_content = re.sub(r'\s', '+', pass_content)
		if filtered_pass_content == '':
			print(f'Should not be empty: {pass_name}', file=sys.stderr)
			continue

		if 'old/' in pass_name:
			continue

		if not re.search(r'^login:', pass_content, flags=re.MULTILINE):
			if pass_name not in ignore_list:
				print(
					f'Should have the "login" field: {pass_name}',
					file=sys.stderr,
				)

			lines = pass_content.split('\n')
			if len(lines) >= 2 and not lines[1].startswith('login:'):
				print(
					f'The "login" field must be on the second line: {pass_name}',
					file=sys.stderr,
				)

		if pass_content.endswith('\n\n'):
			print(f'Should not have ending newline: {pass_name}', file=sys.stderr)

		for match in re.finditer(
			r'\n(?P<key>[^\n]+?):[ \t]*(?P<value>[^\n]+)$',
			pass_content,
			flags=re.MULTILINE,
		):
			key = match.group('key')
			value = match.group('value')

			if re.search(r'[ \t]', key):
				key = re.sub(r'[ \t]+', '_INVALID_WHITESPACE_', key)
				print(
					f'Field identifier should not have spaces: {pass_name}',
					file=sys.stderr,
				)

			if key.startswith('login'):
				property_counts['login'] = property_counts.get('login', 0) + 1
			elif key == 'email':
				property_counts['email'] = property_counts.get('email', 0) + 1
				email_counts[value] = email_counts.get(value, 0) + 1
			elif key == 'username':
				property_counts['username'] = property_counts.get('username', 0) + 1
			elif key == 'comment':
				property_counts['comment'] = property_counts.get('comment', 0) + 1
			elif key.startswith('password_'):
				property_counts['password_'] = property_counts.get('password_', 0) + 1
			elif re.match(r'^(?:secret_|password_)', key):
				property_counts['secret_|password_'] = (
					property_counts.get('secret_|password_', 0) + 1
				)
			elif key.startswith('id'):
				property_counts['id_'] = property_counts.get('id_', 0) + 1
			elif key.startswith('pin'):
				property_counts['pin_'] = property_counts.get('pin_', 0) + 1
			elif key.startswith('q_'):
				property_counts['q_'] = property_counts.get('q_', 0) + 1
			elif key == 'confidential_fields':
				property_counts['confidential_fields'] = (
					property_counts.get('confidential_fields', 0) + 1
				)
			else:
				print(f'Bad field: {pass_name}: {key}', file=sys.stderr)
				property_counts[key] = property_counts.get(key, 0) + 1

	return total_passwords, property_counts, email_counts


def main() -> None:
	pass_store_dir = os.environ.get('PASSWORD_STORE_DIR', '')
	if not pass_store_dir:
		raise SystemExit(
			'ERROR: $PASSWORD_STORE_DIR environment variable is not set\n'
		)

	ignore_list = load_ignore_list(pass_store_dir)

	if '--not-fix-symlinks' not in sys.argv:
		fix_symlinks_interactive(pass_store_dir)

	password_store_dir = Path('~/.home/xdg_data_dir/password-store/').expanduser()
	total_passwords, property_counts, email_counts = lint_password_store(
		password_store_dir, ignore_list
	)

	print('\nKEY SUMMARY:')
	print(f'Total passwords: {total_passwords}')
	for key in property_counts:
		print(f'{key}: {property_counts[key]}')

	print('\nEMAIL SUMMARY:')
	for email in sorted(email_counts, key=email_counts.get, reverse=True):
		print(f'{email}: {email_counts[email]}')


if __name__ == '__main__':
	main()
