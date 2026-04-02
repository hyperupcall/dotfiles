#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Firefox'
declare -g g_sources_file='/etc/apt/sources.list.d/mozilla.sources'

install.debian() {
	sudo apt-get install -y firefox
}

install.ubuntu() {
	# On Ubuntu, by default, the "thunderbird" package uses snap.
	local gpg_file='/etc/apt/keyrings/mozilla.asc'

	pkg.add_apt_key \
		'https://packages.mozilla.org/apt/repo-signing-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://packages.mozilla.org/apt
			Suites: mozilla
			Components: main
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	printf '%s\n' 'Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000' | sudo tee /etc/apt/preferences.d/mozilla >/dev/null
	sudo apt-get -y update
	sudo apt-get install -y firefox
}

install.fedora() {
	sudo dnf -y install firefox
}

install.opensuse() {
	sudo zypper -n install firefox
}

install.arch() {
	sudo pacman -Syu --noconfirm firefox
}

installed() {
	[ -f "$g_sources_file" ] && command -v firefox &>/dev/null
}

util.if_file_sourced || _setup "$@"
