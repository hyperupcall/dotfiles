# shellcheck shell=bash

util.req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

util.run() {
	core.print_info "Executing '$*'"
	if "$@"; then
		return $?
	else
		return $?
	fi
}

util.ensure() {
	if "$@"; then :; else
		core.print_die "'$*' failed (code $?)"
	fi
}

util.ensure_bin() {
	if ! command -v "$1" &>/dev/null; then
		core.print_die "Command '$1' does not exist"
	fi
}

util.is_cmd() {
	if command -v "$1" &>/dev/null; then
		return $?
	else
		return $?
	fi
}

util.clone() {
	local repo="$1"
	local dir="$2"

	if [ ! -d "$dir" ]; then
		core.print_info "Cloning '$repo' to $dir"
		git clone "$repo" "$dir"
	fi
}

util.clone_in_dots() {
	local repo="$1"
	util.clone "$repo" ~/.dots/.repos/"${repo##*/}"
}

util.find_mnt_usb() {
	local usb_partition_uuid="$1"

	local block_dev="/dev/disk/by-uuid/$usb_partition_uuid"
	if [ ! -e "$block_dev" ]; then
		core.print_die "USB Not plugged in"
	fi

	local block_dev_target=
	if ! block_dev_target=$(findmnt -no TARGET "$block_dev"); then
		# 'findmnt' exits failure if cannot find block device. We account
		# for that case with '[ -z "$block_dev_target" ]' below
		:
	fi

	# If the USB is not already mounted
	if [ -z "$block_dev_target" ]; then
		if mountpoint -q /mnt; then
			core.print_die "Directory '/mnt' must not already be a mountpoint"
		fi

		util.run sudo mount "$block_dev" /mnt

		if ! block_dev_target=$(findmnt -no TARGET "$block_dev"); then
			core.print_die "Automount failed"
		fi
	fi

	REPLY=$block_dev_target
}

util.assert_prereq() {
	if [ -z "$XDG_CONFIG_HOME" ]; then
		# shellcheck disable=SC2016
		core.print_die '$XDG_CONFIG_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_DATA_HOME" ]; then
		# shellcheck disable=SC2016
		core.print_die '$XDG_DATA_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_STATE_HOME" ]; then
		# shellcheck disable=SC2016
		core.print_die '$XDG_STATE_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi
}

util.says_yes() {
	local message="${1:-Confirm?}"

	local input=
	until [[ "$input" =~ ^[yn]$ ]]; do
		read -rN1 -p "$message "
		input=${REPLY@L}
	done
	printf '\n'

	if [ "$input" = 'y' ]; then
		return 0
	else
		return 1
	fi
}
