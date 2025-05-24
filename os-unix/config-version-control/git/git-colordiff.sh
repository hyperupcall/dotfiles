#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='colordiff'

main() {
	helper.setup "$@"
}

install.debian() {
	sudo apt-get install -y colordiff
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y colordiff
}

install.opensuse() {
	sudo zypper -n install colordiff
}

install.arch() {
	yay -Syu --noconfirm colordiff
}

installed() {
	command -v colordiff &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
