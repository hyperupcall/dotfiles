#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='darktable'

main() {
	flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install -y --user org.darktable.Darktable
}

installed() {
	flatpak info org.darktable.Darktable &>/dev/null
}
