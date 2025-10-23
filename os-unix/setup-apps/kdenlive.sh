#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Kdenlive'

main() {
	flatpak remote-add --if-not-exists --user flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
	flatpak install -y --user org.kde.kdenlive
}

installed() {
	flatpak info org.kde.kdenlive &>/dev/null
}

util.if_file_sourced || _main "$@"
