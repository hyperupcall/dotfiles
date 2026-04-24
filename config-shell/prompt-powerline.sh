#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='powerline'

install.any() {
	: # TODO
}

installed() {
	command -v powerline &>/dev/null
}

util.if_file_sourced || _setup "$@"
