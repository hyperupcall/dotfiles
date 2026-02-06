#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='darktable'

# TODO: option for install via appimage. meaning, prompt if multiple installation options
main() {
	flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install -y --user org.darktable.Darktable
}

installed() {
	flatpak info org.darktable.Darktable &>/dev/null
}
