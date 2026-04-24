#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Synthing'
declare -g g_sources_file='/etc/apt/sources.list.d/syncthing.sources'

install.debian() {
	local gpg_file="/etc/apt/keyrings/syncthing-archive-keyring.gpg"

	pkg.add_apt_key \
		'https://syncthing.net/release-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
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
	[ -f "$g_sources_file" ] && command -v syncthing &>/dev/null
}

util.if_file_sourced || _setup "$@"
