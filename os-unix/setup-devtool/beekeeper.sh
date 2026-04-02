#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Beekeeper Studio'
declare -g g_sources_file='/etc/apt/sources.list.d/beekeeper-studio-app.sources'

install.ubuntu() {
	local gpg_file='/usr/share/keyrings/beekeeper.asc'

	pkg.add_apt_key 'https://deb.beekeeperstudio.io/beekeeper.key' \
		"$gpg_file"

	pkg.add_apt_repository \
	"$g_sources_file" "
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
	[ -f "$g_sources_file" ] && command -v beekeeper-studio &>/dev/null
}

util.if_file_sourced || _setup "$@"
