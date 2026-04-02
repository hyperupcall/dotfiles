#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='fish'

install.debian() {
	sudo apt-get install -y fish
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	command -v fish &>/dev/null && command -v fish_indent &>/dev/null
}

util.if_file_sourced || _setup "$@"
