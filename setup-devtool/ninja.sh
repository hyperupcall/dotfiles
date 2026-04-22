#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Ninja'

install.ubuntu() {
	sudo apt-get -y install ninja-build
}

installed() {
	command -v ninja &>/dev/null
}

util.if_file_sourced || _setup "$@"
