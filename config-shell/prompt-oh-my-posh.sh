#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='oh-my-posh'

install.any() {
	: # TODO
}

installed() {
	command -v oh-my-posh &>/dev/null
}

util.if_file_sourced || _setup "$@"
