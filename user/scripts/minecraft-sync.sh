#!/usr/bin/env bash

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
folders=(~/.minecraft "${XDG_DATA_HOME:-~/.local/share}"/multimc/instances/*/.minecraft)

for mcFolder in "${folders[@]}"; do
	files=(optionsLC.txt optionsof.txt optionsshaders.txt options.txt servers.dat servers.dat_old)
	for file in "${files[@]}"; do
		echo "File: $mcFolder/$file"

		if [ ! -L "$mcFolder/$file" ]; then
			remove "$mcFolder/$file"
			ln -s "$base/files/$file" "$mcFolder/$file"
		fi
	done
done

for mcFolder in "${folders[@]}"; do
	declare -a l=(resourcepacks shaderpacks)
	for folder in "${l[@]}"; do
		echo "Folder: $mcFolder"

		if [ -d "$mcFolder/$folder" ] && [ ! -L "$mcFolder/$folder" ]; then
			for file in "$mcFolder/$folder"/*; do
				remove "$file"
			done
			rmdir "$mcFolder/$folder"
		elif [ -L "$mcFolder/$folder" ]; then
			unlink "$mcFolder/$folder"
		fi

		echo "linking $folder"
		ln -sf "$base/$folder" "$mcFolder"
	done
done
