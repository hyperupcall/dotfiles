#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Flatpak'

install.debian() {
	sudo apt install flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	# TODO: check
	sudo apt-get install plasma-discover-backend-flatpak
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	# Installed by default.
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install.opensuse() {
	sudo zypper install flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install.arch() {
	sudo pacman -S flatpak
}

installed() {
	command -v flatpak &>/dev/null
}

util.if_file_sourced || _setup "$@"
