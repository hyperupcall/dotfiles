#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'sqlitebrowser' "$@"
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

main "$@"
