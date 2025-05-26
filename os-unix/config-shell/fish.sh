#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='fish'

main() {
	helper.setup "$@"
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

util.if_file_sourced || _main "$@"
