#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='tilix'

main() {
	helper.setup_distro_package 'tilix' 'tilix'
}

util.if_file_sourced || _main "$@"
