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

ensure_dirs() {
	for dir; do
		if [ ! -d "$dir" ]; then
			die "Directory '$dir' does not exist"
		fi
	done
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

	if [[ $flag_host != @(desktop|laptop) ]]; then
		die "Value '$flag_host' not supported"
	fi

	# Trailing slashes required so rsync copies content of directories
	find_mnt_usb '6af304fc-10e2-4229-ae8c-ae64f3f0ea18'
	local mnt="$REPLY"

	if [ "$flag_host" = 'desktop' ]; then
		local destDir="$mnt/desktop-stuff"
		mkdir -p "$destDir"

		local -a desktopDirs=(~/Docs/Knowledge2 ~/Docs/School ~/Pics)
		ensure_dirs "${desktopDirs[@]}"

		rsync -avL --delete --exclude '.Trash-1000' "${desktopDirs[@]}" "$destDir"
	elif [ "$flag_host" = 'laptop' ]; then
		local destDir="$mnt/laptop-stuff"
		mkdir -p "$destDir"

		local -a laptopDirs=(~/Documents)
		ensure_dirs "${laptopDirs[@]}"

		rsync -avL --delete --exclude '.Trash-1000' --exclude 'ignore' "${laptopDirs[@]}" "$destDir"
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
