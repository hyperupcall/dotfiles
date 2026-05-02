#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Firefox'
declare -g g_sources_file='/etc/apt/sources.list.d/mozilla.sources'

install.debian() {
	sudo apt-get install -y firefox
}

install.ubuntu() {
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
	sudo apt-get install -y firefox xdg-desktop-portal-kde
}

install.fedora() {
	sudo dnf -y install firefox xdg-desktop-portal-kde
}

install.opensuse() {
	sudo zypper -n install firefox xdg-desktop-portal-kde
}

install.arch() {
	sudo pacman -Syu --noconfirm firefox xdg-desktop-portal-kde
}

install.installed() {
	[ -f "$g_sources_file" ] && command -v firefox &>/dev/null
}

util.if_file_sourced || _setup "$@"
