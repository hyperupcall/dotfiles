#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='notify-send'

install.debian() {
	sudo apt-get install -y notify-send
}

install.ubuntu() {
	install.debian "$@"
}

install.neon() {
	sudo apt-get install -y libnotify-bin notify-osd
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

util.if_file_sourced || _setup "$@"
