#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='pure'

install.any() {
	: # TODO
}

installed() {
	command -v pure &>/dev/null
}

util.if_file_sourced || _setup "$@"
