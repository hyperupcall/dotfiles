#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='libfuse'

install.debian() {
	sudo apt-get install -y libfuse-dev
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y fuse-devel
}

install.opensuse() {
	sudo zypper -n install fuse-devel
}

install.arch() {
	yay -Syu --noconfirm fuse2
}

install.installed() {
	[ -f /usr/include/fuse.h ]
}

util.if_file_sourced || _setup "$@"
