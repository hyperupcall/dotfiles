#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Synthing'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/syncthing-archive-keyring.gpg"

	pkg.add_apt_key \
		'https://syncthing.net/release-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/syncthing.sources' "
			Types: deb
			URIs: https://apt.syncthing.net/
			Suites: syncthing
			Components: stable
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y syncthing
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	command -v syncthing &>/dev/null
}

util.if_file_sourced || _setup "$@"
