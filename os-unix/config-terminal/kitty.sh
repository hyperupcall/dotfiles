#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='kitty'

main() {
	helper.setup_distro_package 'kitty' 'kitty'
}

util.if_file_sourced || _main "$@"
