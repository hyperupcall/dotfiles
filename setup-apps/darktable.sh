#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='darktable'

install.any() {
	flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install -y --user org.darktable.Darktable
}

install.installed() {
	flatpak info org.darktable.Darktable &>/dev/null
}

util.if_file_sourced || _setup "$@"
