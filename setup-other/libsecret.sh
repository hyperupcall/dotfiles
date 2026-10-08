#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='libsecret'

install.debian() {
	sudo apt-get install -y libsecret-tools
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y libsecret
}

install.opensuse() {
	sudo zypper -n install libsecret-tools
}

install.arch() {
	yay -Syu --noconfirm libsecret
}

install.installed() {
	command -v secret-tool &>/dev/null
}

util.if_file_sourced || _setup "$@"
