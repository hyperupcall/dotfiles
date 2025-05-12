#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='OBS'

main() {
	helper.setup "$@"
}

install.any() {
	if command -v 'apt' &>/dev/null; then
		sudo add-apt-repository -y ppa:obsproject/obs-studio
		sudo apt-get update -y
		sudo apt-get install -y obs-studio
	else
		flatpak remote-add --if-not-exists flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
		flatpak install -y com.obsproject.Studio
	fi
}

util.if_file_sourced || helper.run_main "$@"
