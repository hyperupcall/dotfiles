#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Unity Hub'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/unity.asc"

	pkg.add_apt_key \
		'https://hub.unity3d.com/linux/keys/public' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/unityhub.sources' "
			Types: deb
			URIs: https://hub.unity3d.com/linux/repos/deb
			Suites: stable
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y unityhub
}

util.if_file_sourced || _setup "$@"
