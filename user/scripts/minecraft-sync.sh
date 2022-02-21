#!/usr/bin/env bash

# Syncs subdirectories in minecraft, like `resourcepacks`,
# `saves`, `screenshots`, etc. Use at your own risk!

remove() {
	: "${1:?"Error: remove: Argument 1, file not found"}"

	if command -v trash-put &>/dev/null; then
		trash-put "$1"
	else
		mkdir -p "$base/trash-directory"
		mv "$1" "$base/trash-directory/$1-$RANDOM"
	fi
}

shopt -s nullglob dotglob

base="$HOME/Docs/Games/Minecraft/common-dot-minecraft"
dataDir="${XDG_DATA_HOME:-~/.local/share}"
configDir="${XDG_CONFIG_HOME:-~/.config}"
folders=(
	~/.minecraft
	"$dataDir"/multimc/instances/*/.minecraft
	"$configDir"/hmcl/.minecraft
)

# sync common files
for mcFolder in "${folders[@]}"; do
	echo "SYNCING COMMON FILES: $mcFolder"
	# files=(optionsLC.txt optionsof.txt optionsshaders.txt options.txt servers.dat servers.dat_old)
	files=(servers.dat)

	for file in "${files[@]}"; do

		# unlink "$mcFolder/$file"

		if [ ! -L "$mcFolder/$file" ]; then
			echo "     -> Linking '$mcFolder/$file'"

			[ -e "$mcFolder/$file" ] && {
				cp "$mcFolder/$file" "$base/files/$file"
				remove "$mcFolder/$file"
			}

			ln -sT "$base/files/$file" "$mcFolder/$file"
		fi
	done
done

echo ---

# sync common folders
for mcFolder in "${folders[@]}"; do
	echo "SYNCING COMMON DIRS: $mcFolder"
	declare -a subfolders=(resourcepacks shaderpacks saves screenshots)

	for subfolder in "${subfolders[@]}"; do
		mkdir -p "$base/$subfolder"
		if [ -d "$mcFolder/$subfolder" ] && [ ! -L "$mcFolder/$subfolder" ]; then
			echo "     -> Symlinking '$mcFolder/$subfolder'"

			for file in "$mcFolder/$subfolder"/*; do
				cp -r "$file" "$base/$subfolder"
				remove "$file"
			done
			rmdir "$mcFolder/$subfolder"
		fi

		ln -sT "$base/$subfolder" "$mcFolder/$subfolder"
	done
done
