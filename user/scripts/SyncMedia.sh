#!/usr/bin/env bash

show_help() {
	printf '%s\n' 'Usage: SyncMedia.sh --host=desktop|laptop'
}

die() {
	error "$1. Exiting"
	exit 1
}

error() {
	printf '%s\n' "Error: $1" >&2
}

info() {
	printf '%s\n' "$1"
}

main() {
	local flag_host=
	for arg; do case $arg in
	-h|--help)
		show_help
		exit
		;;
	--host=*)
		IFS='=' read -r key value <<< "$arg"
		flag_host=$value
		;;
	esac done

	if [ -z "$flag_host" ]; then
		show_help
		exit
	fi

	if ! command -v rsync &>/dev/null; then
		die "Must have 'rsync' installed"
	fi

	# Trailing slashes required so rsync copies content of directories
	if [ "$flag_host" = 'desktop' ]; then
		find_mnt_usb '6af304fc-10e2-4229-ae8c-ae64f3f0ea18'

		local destDir="$REPLY/synced-copy"

		mkdir -p "$destDir"

		local -a desktopDirs=(~/Docs/Knowledge2 ~/Docs/School)
		for dir in "${desktopDirs[@]}"; do
			if [ ! -d "$dir" ]; then
				die "Directory '$dir' does not exist"
			fi
		done

		rsync -av --delete "${desktopDirs[@]}" "$destDir"
	elif [ "$flag_host" = 'laptop' ]; then
		find_mnt_usb '6af304fc-10e2-4229-ae8c-ae64f3f0ea18'
		local dir="$REPLY"

	else
		die "Value '$flag_host' not supported"
	fi
}

find_mnt_usb() {
	unset -v REPLY; REPLY=
	local usb_partition_uuid="$1"

	local block_dev="/dev/disk/by-uuid/$usb_partition_uuid"
	if [ ! -e "$block_dev" ]; then
		die "USB Not plugged in"
	fi

	local block_dev_target=
	if ! block_dev_target=$(findmnt -no TARGET "$block_dev"); then
		die "USB not mounted"
	fi

	REPLY=$block_dev_target
}

main "$@"
