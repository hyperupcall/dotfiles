#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='darktable'

# TODO: option for install via appimage. meaning, prompt if multiple installation options
main() {
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install -y org.darktable.Darktable
}
