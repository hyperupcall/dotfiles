#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='konsole'

main() {
	helper.setup_distro_package 'konsole' 'konsole'
}

util.if_file_sourced || _main "$@"
