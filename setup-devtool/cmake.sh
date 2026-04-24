#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='cmake'

install.any() {
	mise install cmake@latest
	# TODO: cmake and lefthook, error when installing since not in path.
	mise use -g cmake@latest
}

installed() {
	command -v cmake &>/dev/null
}

util.if_file_sourced || _setup "$@"
