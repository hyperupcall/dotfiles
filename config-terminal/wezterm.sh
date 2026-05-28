#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='WezTerm'

install.debian() {
	local gpg_file='/usr/share/keyrings/wezterm-fury.gpg'
	local sources_file='/etc/apt/sources.list.d/wezterm.sources'

	pkg.add_apt_key \
		'https://apt.fury.io/wez/gpg.key' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$sources_file" "
			Types: deb
			URIs: https://apt.fury.io/wez/
			Suites: *
			Components: *
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get -y install wezterm
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf copr enable -y wezfurlong/wezterm-nightly
	sudo dnf install -y wezterm
}

install.arch() {
	sudo pacman -Syu --noconfirm wezterm
}

install.installed() {
	command -v wezterm &>/dev/null
}

util.if_file_sourced || _setup "$@"
