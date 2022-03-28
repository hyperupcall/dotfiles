# shellcheck shell=bash

main.dotmgr() {
	set -eo pipefail
	shopt -s dotglob extglob globstar nullglob shift_verbose
	source "$DOTMGR_ROOT_DIR/src/util/print.sh"
	source "$DOTMGR_ROOT_DIR/src/util/util.sh"

	# -------------------------------------------------------- #
	#                    COPY ROOT DOTFILES                    #
	# -------------------------------------------------------- #
	print.info 'Copying root dotfiles'
	local {src,dest}_file=
	for src_file in ~/.dots/system/**; do
		dest_file=${src_file#*/.dots/system}

		if [ -d "$src_file" ]; then
			continue
		fi

		if [[ $src_file == *ignore* ]]; then
			continue
		fi

		sudo mkdir -p "${dest_file%/*}"
		sudo cp -f "$src_file" "$dest_file"
	done; unset -v {src,dest}_file
}
