#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='OBS'

install.debian() {
	sudo add-apt-repository -y ppa:obsproject/obs-studio
	sudo apt-get update -y
	sudo apt-get install -y obs-studio
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	flatpak remote-add --if-not-exists --user flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
	flatpak install -y --user com.obsproject.Studio
}

install.opensuse() {
	install.fedora "$@"
}

install.installed() {
	command -v obs &>/dev/null
}

util.if_file_sourced || _setup "$@"
