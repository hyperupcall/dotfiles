#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='xterm'

main() {
	helper.setup_distro_package 'xterm' 'xterm'
}

util.if_file_sourced || _main "$@"
