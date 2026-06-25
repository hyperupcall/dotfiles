#!/usr/bin/env python3
import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

parser = argparse.ArgumentParser(prog='virtualbox-import-all')
parser.add_argument('--unregister', action='store_true')
args = parser.parse_args()

if shutil.which('VBoxManage') is None:
	print("Must have command 'VBoxManage' installed", file=sys.stderr)
	sys.exit(1)

config_path = Path(__file__).resolve().parent.parent / 'config' / 'setup-private.pl'
if not config_path.is_file():
	print(f'Failed to load setup-private.pl: {config_path}', file=sys.stderr)
	sys.exit(1)

match = re.search(r"_private_virtualbox_dir\s*=>\s*'([^']+)'", config_path.read_text())
if not match:
	print('Failed to find _private_virtualbox_dir in setup-private.pl', file=sys.stderr)
	sys.exit(1)

virtualbox_dir = Path(match.group(1))
subprocess.run(['VBoxManage', 'setproperty', 'machinefolder', str(virtualbox_dir)], check=False)

if args.unregister:
	proc = subprocess.run(
		['VBoxManage', 'list', 'vms'],
		capture_output=True,
		text=True,
		check=True,
	)
	for line in proc.stdout.splitlines():
		vm_match = re.match(r'^"(.+)" \{(.+)\}$', line)
		if not vm_match:
			print(f'Capture group failed on line: {line}', file=sys.stderr)
			sys.exit(1)
		name, uuid = vm_match.groups()
		print(f'Removing "{name}"')
		subprocess.run(['VBoxManage', 'unregistervm', uuid], check=False)
	sys.exit(0)

if not virtualbox_dir.is_dir():
	print(f'Failed to find directory: {virtualbox_dir}', file=sys.stderr)
	sys.exit(1)

for entry in virtualbox_dir.iterdir():
	if not entry.is_dir():
		continue

	vbox_file = entry / f'{entry.name}.vbox'
	if vbox_file.is_file():
		print(f'REGISTERING {vbox_file}')
		subprocess.run(['VBoxManage', 'registervm', str(vbox_file)], check=False)
		continue

	for subentry in entry.iterdir():
		if not subentry.is_dir():
			continue

		sub_vbox = subentry / f'{subentry.name}.vbox'
		if sub_vbox.is_file():
			print(f'REGISTERING {sub_vbox}')
			subprocess.run(['VBoxManage', 'registervm', str(sub_vbox)], check=False)
