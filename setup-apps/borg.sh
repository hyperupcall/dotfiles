#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Borg'

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

install.installed() {
	command -v borg &>/dev/null
}

util.if_file_sourced || _setup "$@"
