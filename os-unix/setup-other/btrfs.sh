#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='btrfs'

main() {
	util.install_by_setup "$@"
}

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

util.if_file_sourced || _setup "$@"
