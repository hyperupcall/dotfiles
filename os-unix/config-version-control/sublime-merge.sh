#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Sublime Text'
declare -g g_sources_file='/etc/apt/sources.list.d/sublime-text.sources'

install.debian() {
	local gpg_file="/etc/apt/keyrings/sublimehq-archive.asc"

	pkg.add_apt_key \
		'https://download.sublimetext.com/sublimehq-pub.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://download.sublimetext.com/
			Suites: apt/stable/
			Components:
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y sublime-merge
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	[ -f "$g_sources_file" ] && command -v smerge &>/dev/null
}

util.if_file_sourced || _setup "$@"
