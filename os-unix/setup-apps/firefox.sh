#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Firefox'

main() {
	util.install_by_setup "$@"
}

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
		'/etc/apt/sources.list.d/mozilla.sources' "
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

install.arch() {
	sudo pacman -Syu --noconfirm firefox
}

install.opensuse() {
	sudo zypper -n install firefox
}

installed() {
	command -v firefox &>/dev/null
}

util.if_file_sourced || _setup "$@"
