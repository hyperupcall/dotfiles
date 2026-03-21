#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Caddy'
declare -g g_sources_file='/etc/apt/sources.list.d/caddy-stable.sources'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
	local gpg_file="/etc/apt/keyrings/caddy-stable.asc"

	pkg.add_apt_key \
		'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb deb-src
			URIs: https://dl.cloudsmith.io/public/caddy/stable/deb/debian
			Suites: any-version
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y caddy
}

installed() {
	[ -f "$g_sources_file" ] && command -v caddy &>/dev/null
}

util.if_file_sourced || _setup "$@"
