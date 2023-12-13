#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install ZFS?'; then
		install.zfs
	fi
}

install.zfs() {
	pkg.add_apt_repository \
		"deb https://deb.debian.org/debian bookworm-backports main contrib
deb-src https://deb.debian.org/debian bookworm-backports main contrib" \
		'/etc/apt/sources.list.d/bookworm-backports.list'
    
    dest_file=/etc/apt/preferences.d/90_zfs
    printf '%s\n' "Package: src:zfs-linux
Pin: release n=bookworm-backports
Pin-Priority: 990" | sudo tee "$dest_file" >/dev/null

    sudo apt update
    sudo apt install dpkg-dev linux-headers-generic linux-image-generic
    sudo apt install zfs-dkms zfsutils-linux

}

main "$@"
