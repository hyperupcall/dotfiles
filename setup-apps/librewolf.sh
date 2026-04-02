#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='LibreWolf'

install.debian() {
	sudo apt-get -y update
	sudo apt-get install -y extrepo
	sudo extrepo enable librewolf
	sudo apt-get -y update
	sudo apt-get install -y librewolf -y
}

install.ubuntu() {
	install.debian "$@"
}

install.arch() {
	sudo pacman -Syu --noconfirm librewolf-bin
}

installed() {
	command -v librewolf &>/dev/null
}

util.if_file_sourced || _setup "$@"
