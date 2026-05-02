#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Flatpak'

install.debian() {
	sudo apt-get install -y flatpak
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	sudo apt-get install -y plasma-discover-backend-flatpak
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	# flatpak installed by default.
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install.opensuse() {
	sudo zypper install -y flatpak
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install.arch() {
	sudo pacman -Syu --noconfirm flatpak
}

install.installed() {
	command -v flatpak &>/dev/null
}

install.caveats() {
	printf '%s\n' "Depending on distribution, plasma-discover-backend-flatpak may still need to be installed."
}

util.if_file_sourced || _setup "$@"
