#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Firefox' "$@"
}

install.debian() {
	sudo apt-get install -y firefox
}

install.ubuntu() {
	local gpg_file='/etc/apt/keyrings/mozilla.asc'

	pkg.add_apt_key \
		'https://packages.mozilla.org/apt/repo-signing-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=amd64,arm64 signed-by=$gpg_file] https://packages.mozilla.org/apt mozilla main" \
		'/etc/apt/sources.list.d/mozilla.list'

	printf '%s\n' 'Package: *
Pin: origin packages.mozilla.orgw
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

util.if_file_sourced || main "$@"
