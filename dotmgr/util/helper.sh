# shellcheck shell=bash

helper.find_mnt_usb() {
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
