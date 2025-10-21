#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Beekeeper Studio'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	local gpg_file='/usr/share/keyrings/beekeeper.asc'

	pkg.add_apt_key 'https://deb.beekeeperstudio.io/beekeeper.key' \
		"$gpg_file"

	pkg.add_apt_repository \
	'/etc/apt/sources.list.d/beekeeper-studio-app.sources' "
		Types: deb
		URIs: https://deb.beekeeperstudio.io
		Suites: stable
		Components: main
		Architectures: $(dpkg --print-architecture)
		signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y beekeeper-studio
}

installed() {
	command -v beekeeper-studio &>/dev/null
}

util.if_file_sourced || _setup "$@"
