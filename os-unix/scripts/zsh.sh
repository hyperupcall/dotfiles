#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'zsh' "$@"
}

install.debian() {
	sudo apt-get install -y zsh
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y zsh
}

install.opensuse() {
	sudo zypper -n install zsh
}

install.arch() {
	yay -Syu --noconfirm zsh
}

installed() {
	command -v zsh &>/dev/null
}

configure() {
	# TODO: Edit dotfiles.c, and d compile & reconfigure
	:
}

util.if_file_sourced || main "$@"
