#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='OBS'

main() {
	if command -v 'apt' &>/dev/null; then
		sudo add-apt-repository -y ppa:obsproject/obs-studio
		sudo apt-get update -y
		sudo apt-get install -y obs-studio
	else
		flatpak remote-add --if-not-exists flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
		flatpak install -y com.obsproject.Studio
	fi
}

installed() {
	command -v obs &>/dev/null
}

util.if_file_sourced || _main "$@"
