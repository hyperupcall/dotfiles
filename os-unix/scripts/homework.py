#!/usr/bin/env python3
import os
import re
import sys
from datetime import datetime
from pathlib import Path

parent_dir = os.path.basename(os.getcwd())

if not parent_dir.startswith('hw'):
	print(f"Error: The current directory name '{parent_dir}' does not start with 'hw'.")
	sys.exit(1)

if os.path.isdir('output'):
	print('Error: Subdirectory "output" already exists in, wrong location.')
	sys.exit(1)

for root, _, files in os.walk('.'):
	for cur_filename in files:
		if not (cur_filename.endswith('.java') or cur_filename.endswith('.cpp')):
			continue
		if cur_filename != 'Main.java' and cur_filename != 'main.cpp':
			continue

		cur_filepath = os.path.join(root, cur_filename)
		with open(cur_filepath, 'r', encoding='utf-8') as f:
			content = f.read()

		base_name = (
			os.path.basename(os.path.dirname(cur_filepath))
			.replace('_in_cpp', '')
			.replace('_in_java', '')
		)
		new_filename = (
			f'{Path(cur_filepath).stem}_{base_name}{Path(cur_filepath).suffix}'
		)
		new_filepath = os.path.join(root, new_filename)

		original_content = content
		content = re.sub(r'(Title:\s*).*', rf'\g<1>{new_filename}', content)
		content = re.sub(r'(ID:\s*).*', r'\g<1>1001', content)
		content = re.sub(r'(Name:\s*).*', r'\g<1>Edwin Kofler', content)
		content = re.sub(
			r'(Date:\s*).*', rf'\g<1>{datetime.now().strftime("%m/%d/%Y")}', content
		)
		if content != original_content:
			with open(cur_filepath, 'w', encoding='utf-8') as f:
				f.write(content)
			print(f'Updated content for: {cur_filepath}')

		if new_filename != cur_filename:
			os.rename(cur_filepath, new_filepath)
			print(f'Renamed: {cur_filepath} -> {new_filepath}')
		os.symlink(new_filename, cur_filepath)
