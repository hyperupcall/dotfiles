#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='terminator'

main() {
	helper.setup_distro_package 'terminator' 'terminator'
}

util.if_file_sourced || _main "$@"
