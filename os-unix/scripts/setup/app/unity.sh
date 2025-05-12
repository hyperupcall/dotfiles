#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Unity Hub'

main() {
	helper.setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/unity.asc"

	pkg.add_apt_key \
		'https://hub.unity3d.com/linux/keys/public' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://hub.unity3d.com/linux/repos/deb stable main" \
		'/etc/apt/sources.list.d/unityhub.list'

	sudo apt-get update -y
	sudo apt-get install -y unityhub
}

util.if_file_sourced || helper.run_main "$@"
