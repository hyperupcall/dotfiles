#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='less'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	sudo apt-get install -y source-highlight
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y source-highlight
}

install.opensuse() {
	sudo zypper -n install source-highlight
}

install.arch() {
	yay -Syu --noconfirm source-highlight
}

installed() {
	command -v source-highlight &>/dev/null
}

util.if_file_sourced || _setup "$@"
