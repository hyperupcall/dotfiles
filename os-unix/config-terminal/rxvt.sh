#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='rxvt'

main() {
	helper.setup_distro_package 'rxvt' 'rxvt'
}

util.if_file_sourced || _main "$@"
