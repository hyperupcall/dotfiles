#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Borg'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	sudo apt-get install -y borgbackup
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y borgbackup
}

install.opensuse() {
	sudo zypper -n install borgbackup
}

install.arch() {
	sudo pacman -Syu --noconfirm borgbackup
}

util.if_file_sourced || _setup "$@"
