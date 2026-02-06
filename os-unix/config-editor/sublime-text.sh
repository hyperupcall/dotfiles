#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Sublime Text'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/sublimehq-archive.asc"

	pkg.add_apt_key \
		'https://download.sublimetext.com/sublimehq-pub.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/sublime-text.sources' "
			Types: deb
			URIs: https://download.sublimetext.com/
			Suites: apt/stable/
			Components:
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y sublime-text
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	command -v subl &>/dev/null
}

util.if_file_sourced || _setup "$@"
