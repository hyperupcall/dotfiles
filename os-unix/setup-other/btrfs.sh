#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='btrfs'

install.debian() {
	sudo apt-get -y update
	sudo apt-get -y install btrfs-progs
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf -y update
	sudo dnf -y install btrfs-progs
}

install.opensuse() {
	sudo zypper refresh
	sudo zypper -n install btrfs-progs
}

install.arch() {
	yay -Syu --noconfirm btrfs-progs
}

installed() {
	command -v btrfs &>/dev/null
}

util.if_file_sourced || _setup "$@"
