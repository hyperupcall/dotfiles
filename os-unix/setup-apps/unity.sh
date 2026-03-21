#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Unity Hub'
declare -g g_sources_file='/etc/apt/sources.list.d/unityhub.sources'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/unity.asc"

	pkg.add_apt_key \
		'https://hub.unity3d.com/linux/keys/public' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://hub.unity3d.com/linux/repos/deb
			Suites: stable
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y unityhub
}

installed() {
	[ -f "$g_sources_file" ] && command -v unityhub &>/dev/null
}

util.if_file_sourced || _setup "$@"
