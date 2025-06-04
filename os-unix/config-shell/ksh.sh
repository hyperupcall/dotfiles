#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='ksh'

main() {
	util.install_by_setup_distro_package 'ksh' 'ksh'
}

util.if_file_sourced || _setup "$@"
