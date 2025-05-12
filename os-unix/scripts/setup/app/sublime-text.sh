#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Sublime Text'

main() {
	helper.setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/sublimehq-archive.asc"

	pkg.add_apt_key \
		'https://download.sublimetext.com/sublimehq-pub.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://download.sublimetext.com/ apt/stable/" \
		'/etc/apt/sources.list.d/sublime-text.list'

	sudo apt-get update -y
	sudo apt-get install -y sublime-text
}

util.if_file_sourced || helper.run_main "$@"
