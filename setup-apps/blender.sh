#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='blender'

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

install.installed() {
	command -v blender &>/dev/null
}

util.if_file_sourced || _setup "$@"
