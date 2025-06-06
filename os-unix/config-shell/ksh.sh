#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='ksh'

main() {
	util.install_by_setup_distro_package 'ksh' 'ksh'
}

installed() {
	command -v 'ksh' &>/dev/null
}

util.if_file_sourced || _setup "$@"
