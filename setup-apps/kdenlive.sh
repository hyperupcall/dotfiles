#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Kdenlive'

install.any() {
	flatpak remote-add --if-not-exists --user flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
	flatpak install -y org.kde.kdenlive
}

installed() {
	flatpak info org.kde.kdenlive &>/dev/null
}

util.if_file_sourced || _setup "$@"
