#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='fish'

main() {
	util.install_by_setup "$@"
}

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
