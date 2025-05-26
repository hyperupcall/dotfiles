#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='cmake'

main() {
	helper.setup "$@"
}

install.any() {
	mise install cmake@latest
	mise use -g cmake@latest
}

installed() {
	command -v cmake &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
