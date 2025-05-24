#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Synthing'

main() {
	helper.setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/syncthing-archive-keyring.gpg"

	pkg.add_apt_key \
		'https://syncthing.net/release-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://apt.syncthing.net/ syncthing stable" \
		'/etc/apt/sources.list.d/syncthing.list'

	sudo apt-get update -y
	sudo apt-get install -y syncthing
}

util.if_file_sourced || helper.run_main "$@"
