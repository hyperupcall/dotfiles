#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='terminology'

main() {
	helper.setup_distro_package 'terminology' 'terminology'
}

util.if_file_sourced || _main "$@"
