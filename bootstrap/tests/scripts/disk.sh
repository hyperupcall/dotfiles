#!/usr/bin/env bash
set -euEo pipefail

#Could not allocate memory error
#guestfish -a ./tests/data/mkosi/writable-image.qcow2 < ./tests/scripts/guestfish
#virt-make-fs --partition=gpt -s +100MiB -F qcow2 -t ext4 ./tests/shared tests/shared.qcow2

declare -r mnt='./data/mnt'
declare -r file='./data/shared.raw'

if mountpoint "$mnt" &>/dev/null; then
	echo "Error: Cannot continue. '$mnt' is a mountpoint. Please unmount it"
	exit 1
fi

if ! rm -f "$file"; then
	echo "Error: Failure to remove previous '$file'" 1>&2
	exit 1
fi

if ! touch "$file"; then
	echo "Error: Failure to create file '$file'" 1>&2
	exit 1
fi

if ! dd if=/dev/zero of="$file" bs=1024 count=102400; then
	echo "Error: Failure to fill file '$file'" 1>&2
	exit 1
fi

<<< 'label: gpt' sfdisk "$file"
<<< 'start=2048' sfdisk "$file"

if ! loopDev="$(sudo losetup -fP --show "$file")"; then
	echo "Error: Failure to create loop device" 1>&2
	exit 1
fi

if ! sudo mkfs.ext4 "${loopDev}p1"; then
	echo "Error: Failure to format mounted loop device" 1>&2
	exit 1
fi

if ! sudo mkdir -p "$mnt"; then
	echo "Error: Failure to create directory for mounting at '$mnt'" 1>&2
	exit 1
fi


if ! sudo mount "${loopDev}p1" "$mnt"; then
	echo "Error: Failure to mount loop device at '$mnt'" 1>&2
	exit 1
fi

if ! sudo cp -r 'shared' "$mnt"; then
	echo "Error: Failure to copy 'shared' directory to '$mnt'" 1>&2
	exit 1
fi

if ! sudo umount "$mnt"; then
	echo "Error: Failure to unmount '$mnt'" 1>&2
	exit 1
fi
