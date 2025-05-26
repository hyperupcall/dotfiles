#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='alacritty'

main() {
	helper.setup_distro_package 'alacritty' 'alacritty'
}

util.if_file_sourced || _main "$@"
