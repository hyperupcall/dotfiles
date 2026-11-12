#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Cloudflare WARP'
declare -g g_sources_file='/etc/apt/sources.list.d/cloudflare-warp.sources'

install.debian() {
	local gpg_file='/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg'

	pkg.add_apt_key \
		'https://pkg.cloudflareclient.com/pubkey.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://pkg.cloudflareclient.com/
			Suites: $(lsb_release --codename --short)
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get -y install cloudflare-warp
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	pkg.add_dnf_repository 'https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo'

	sudo dnf -y update
	sudo dnf -y install cloudflare-warp
}

install.installed() {
	command -v warp-cli &>/dev/null
}

util.if_file_sourced || _setup "$@"
