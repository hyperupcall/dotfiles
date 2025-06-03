#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='notify-send'

main() {
	helper.setup "$@"
}

install.debian() {
	sudo apt-get install -y notify-send
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y notify-send
}

install.opensuse() {
	sudo zypper -n install notify-send
}

install.arch() {
	yay -Syu --noconfirm notify-send
}

installed() {
	command -v notify-send &>/dev/null
}

util.if_file_sourced || _main "$@"
