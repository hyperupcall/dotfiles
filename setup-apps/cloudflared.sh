#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='cloudflared'
declare -g g_sources_file='/etc/apt/sources.list.d/cloudflared.sources'

install.debian() {
	local gpg_file='/usr/share/keyrings/cloudflare-main.gpg'

	pkg.add_apt_key \
		'https://pkg.cloudflare.com/cloudflare-main.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://pkg.cloudflare.com/cloudflared
			Suites: any
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get -y install cloudflared
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	pkg.add_dnf_repository 'https://pkg.cloudflare.com/cloudflared.repo'

	sudo dnf -y install cloudflared
}

install.installed() {
	command -v cloudflared &>/dev/null
}

util.if_file_sourced || _setup "$@"
