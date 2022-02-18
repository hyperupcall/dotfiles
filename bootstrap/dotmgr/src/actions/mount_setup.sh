# shellcheck shell=bash

# Name:
# Setup Mounts
#
# Description:
# Sets up the proper BTRFS mounts in fstab

actions() {
	if ! grep -q /storage/ur /etc/fstab; then
		sudo -v
		local mnt="/storage/ur"
		printf "PARTUUID=c875b5ca-08a6-415e-bc11-fc37ec94ab8f  $mnt  btrfs  defaults,noatime,X-mount.mkdir  0 0" | sudo tee -a /etc/fstab >/dev/null
		sudo mount "$mnt"
	fi
}
