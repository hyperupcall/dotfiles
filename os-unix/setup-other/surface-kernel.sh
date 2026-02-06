#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

main() {
	if ! util.confirm "Are all your kernel modules installed as DKMS?"; then
		exit 0
	fi

	util.install_by_setup 'Surface Kernel' "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/linux-surface.asc"

	pkg.add_apt_key \
		'https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/linux-surface.sources' "
			Types: deb
			URIs: https://pkg.surfacelinux.com/debian
			Suites: release
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y linux-image-surface linux-headers-surface libwacom-surface iptsd
	sudo apt-get install -y linux-surface-secureboot-mok # Do this after.
	sudo update-grub
}

install.ubuntu() {
	install.debian "$@"
}

util.if_file_sourced || _setup "$@"
