#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Surface Kernel'
declare -g g_sources_file='/etc/apt/sources.list.d/linux-surface.sources'

install.debian() {
	installation_assert

	local gpg_file="/etc/apt/keyrings/linux-surface.asc"

	pkg.add_apt_key \
		'https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
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

install.installed() {
	[ -f "$g_sources_file" ] && command -v linux-surface &>/dev/null
}

installation_assert() {
	if ! util.confirm "Are all your kernel modules installed as DKMS?"; then
		exit 0
	fi
}

util.if_file_sourced || _setup "$@"
