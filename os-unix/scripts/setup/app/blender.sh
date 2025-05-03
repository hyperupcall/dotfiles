#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'blender' "$@"
}

install.debian() {
	sudo apt-get install -y blender
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y blender
}

install.opensuse() {
	sudo zypper -n install blender
}

install.arch() {
	sudo pacman -Syu --noconfirm blender
}

installed() {
	command -v blender &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
