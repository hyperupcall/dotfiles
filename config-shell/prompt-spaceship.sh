#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='spaceship'

install.any() {
	: # TODO
}

installed() {
	command -v spaceship &>/dev/null
}

util.if_file_sourced || _setup "$@"
