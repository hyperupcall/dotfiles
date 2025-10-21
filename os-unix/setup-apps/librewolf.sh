#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='LibreWolf'

main() {
	util.install_by_setup "$@"
}

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
