#!/usr/bin/env python3
import os
import re
import sys
from datetime import datetime

parent_dir = os.path.basename(os.getcwd())

if not parent_dir.startswith('hw'):
	print(f"Error: The current directory name '{parent_dir}' does not start with 'hw'.")
	sys.exit(1)

if os.path.isdir('output'):
	print('Error: Subdirectory "output" already exists in, wrong location.')
	sys.exit(1)

for root, _, files in os.walk('.'):
	for file in files:
		if not (file.endswith('.java') or file.endswith('.cpp')):
			continue

		today = datetime.now().strftime('%m/%d/%Y')
		current_file_path = os.path.join(root, file)

		with open(current_file_path, 'r', encoding='utf-8') as f:
			content = f.read()

		original_content = content

		base_name, extension = os.path.splitext(file)
		title_suffix = parent_dir
		title_suffix = title_suffix.replace('_in_cpp', '')
		title_suffix = title_suffix.replace('_in_java', '')

		new_file_title = f'{base_name}_{title_suffix}{extension}'

		content = re.sub(r'(Title:\s*).*', rf'\g<1>{new_file_title}', content)
		content = re.sub(r'(ID:\s*).*', r'\g<1>1001', content)
		content = re.sub(r'(Name:\s*).*', r'\g<1>Edwin Kofler', content)
		content = re.sub(r'(Date:\s*).*', rf'\g<1>{today}', content)

		if content != original_content:
			with open(current_file_path, 'w', encoding='utf-8') as f:
				f.write(content)
			print(f'Updated content for: {current_file_path}')

		if new_file_title != file:
			new_file_path = os.path.join(root, new_file_title)
			os.rename(current_file_path, new_file_path)
			print(f'Renamed: {current_file_path} -> {new_file_path}')
