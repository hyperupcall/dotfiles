#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='sqlitebrowser'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	sudo add-apt-repository -y ppa:linuxgndu/sqlitebrowser
	sudo apt-get update -y
	sudo apt-get install -y sqlitebrowser
}

install.ubuntu() {
	sudo apt-get update -y
	sudo apt-get install -y sqlitebrowser
}

install.fedora() {
	sudo dnf -y install sqlitebrowser
}

install.opensuse() {
	sudo zypper -n install sqlitebrowser
}

install.arch() {
	sudo pacman -Syu --noconfirm sqlitebrowser
}

util.if_file_sourced || _setup "$@"
