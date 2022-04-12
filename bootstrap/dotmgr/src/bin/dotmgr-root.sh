# shellcheck shell=bash

main.dotmgr() {
	set -eo pipefail
	shopt -s dotglob extglob globstar nullglob shift_verbose
	source "$DOTMGR_ROOT/src/util/print.sh"
	source "$DOTMGR_ROOT/src/util/util.sh"


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


	# -------------------------------------------------------- #
	#                          GROUPS                          #
	# -------------------------------------------------------- #
	local user="$SUDO_USER"
	if [ -z "$user" ]; then
		print.die 'Failed to determine user running as sudo'
	fi

	print.info "Adding groups to user '$user'"
	must_group "$user" 'docker'
	must_group "$user" 'vboxusers'
	must_group "$user" 'libvirt'
	must_group "$user" 'kvm'
}

must_group() {
	local user="$1"
	local group="$2"

	local output=
	if output=$(groupadd "$group" 2>&1); then
		print.info "Creating group '$group'"
	else
		local code=$?
		if ((code != 9)); then
			print.warn "Failed to create group '$group'"
			printf '%s\n' "  -> $output"
		fi
	fi

	if ! usermod -aG "$group" "$user"; then
		print.warn "Failed to add user '$user' to group '$group'"
	fi
}
