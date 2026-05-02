#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Ninja'

install.ubuntu() {
	sudo apt-get -y install ninja-build
}

install.installed() {
	command -v ninja &>/dev/null
}

util.if_file_sourced || _setup "$@"
