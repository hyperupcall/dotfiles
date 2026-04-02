#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='MullvadVPN'
declare -g g_sources_file='/etc/apt/sources.list.d/mullvad.sources'

install.debian() {
	local gpg_file='/usr/share/keyrings/mullvad.asc'

	pkg.add_apt_key \
		'https://repository.mullvad.net/deb/mullvad-keyring.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://repository.mullvad.net/deb/stable
			Suites: stable
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get -y install mullvad-vpn
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	pkg.add_dnf_repository 'https://repository.mullvad.net/rpm/stable/mullvad.repo'

	sudo dnf -y update
	sudo dnf -y install mullvad-vpn
}

installed() {
	[ -f "$g_sources_file" ] && command -v mullvad &>/dev/null
}

util.if_file_sourced || _setup "$@"
