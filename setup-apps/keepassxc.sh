#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='KeePassXC'

install.any() {
	flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install -y --user flathub org.keepassxc.KeePassXC
}

install.installed() {
	flatpak info org.keepassxc.KeePassXC &>/dev/null
}

util.if_file_sourced || _setup "$@"
