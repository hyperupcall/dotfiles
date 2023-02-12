# shellcheck shell=bash

# Name:
# Primary
#
# Description:
# Adds user to various groups

main() {
	source "$DOTMGR_ROOT/src/util/source.sh"

	# -------------------------------------------------------- #
	#                    COPY ROOT DOTFILES                    #
	# -------------------------------------------------------- #
	# core.print_info 'Copying root dotfiles'
	# declare {src,dest}_file=
	# for src_file in ~/.dotfiles/system/**; do
	# 	dest_file=${src_file#*/.dotfiles/system}

	# 	if [ -d "$src_file" ]; then
	# 		continue
	# 	fi

	# 	if [[ $src_file == *ignore* ]]; then
	# 		continue
	# 	fi

	# 	sudo mkdir -p "${dest_file%/*}"
	# 	sudo cp -f "$src_file" "$dest_file"
	# done; unset -v {src,dest}_file


	# -------------------------------------------------------- #
	#                          GROUPS                          #
	# -------------------------------------------------------- #
	declare user="$SUDO_USER"
	if [ -z "$user" ]; then
		core.print_die 'Failed to determine user running as sudo'
	fi

	core.print_info "Adding groups to user '$user'"
	must_group "$user" 'docker'
	must_group "$user" 'vboxusers'
	must_group "$user" 'libvirt'
	must_group "$user" 'kvm'
	must_group "$user" 'nordvpn'
	must_group "$user" 'input'
}

must_group() {
	declare user="$1"
	declare group="$2"

	declare output=
	if output=$(groupadd "$group" 2>&1); then
		core.print_info "Creating group '$group'"
	else
		declare code=$?
		if ((code != 9)); then
			core.print_warn "Failed to create group '$group'"
			printf '%s\n' "  -> $output"
		fi
	fi

	if usermod -aG "$group" "$user"; then
		core.print_info "Added user '$user' to group '$group'"
	else
		core.print_warn "Failed to add user '$user' to group '$group'"
	fi
}

main "$@"
