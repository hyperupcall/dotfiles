#!/usr/bin/env bash

# use at your own risk!!!
# create backups!!!

remove() {
	: "${1:?"Error: remove: Argument 1, file not found"}"

	if [ -e "$1" ] && command -v trash-put &>/dev/null; then
		trash-put "$1"
	else
		rm "$1"
	fi
}

shopt -s nullglob

base=~/Docs/minecraft-common
dataDir="${XDG_DATA_HOME:-~/.local/share}"
configDir="${XDG_CONFIG_HOME:-~/.config}"
folders=(~/.minecraft "$dataDir"/multimc/instances/*/.minecraft "$configDir"/hmcl/.minecraft)

# sync common files
for mcFolder in "${folders[@]}"; do
	files=(optionsLC.txt optionsof.txt optionsshaders.txt options.txt servers.dat servers.dat_old)
	for file in "${files[@]}"; do
		echo "File: $mcFolder/$file"

		if [ ! -L "$mcFolder/$file" ]; then
			cp "$file" "$base/files/$file"
			echo "$file: COPY AND REMOVE ORIGINAL"
			remove "$mcFolder/$file"
			ln -s "$base/files/$file" "$mcFolder/$file"
		fi
	done
done

# sync common folders
for mcFolder in "${folders[@]}"; do
	declare -a l=(resourcepacks shaderpacks saves screenshots)
	for folder in "${l[@]}"; do
		echo "Folder: $mcFolder"
		mkdir -p "$base/$folder"

		if [ -d "$mcFolder/$folder" ] && [ ! -L "$mcFolder/$folder" ]; then
			echo "Subfolder: $mcFolder/$folder"
			for file in "$mcFolder/$folder"/*; do
				cp -r "$file" "$base/$folder"
				echo "$file: COPY AND REMOVE ORIGINAL"
				remove "$file"
			done
			rmdir "$mcFolder/$folder"
		fi

		ln -sf "$base/$folder" "$mcFolder"
	done
done