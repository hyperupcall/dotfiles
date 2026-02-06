#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='terminator'

main() {
	util.install_by_setup_distro_package 'terminator' 'terminator'
}

installed() {
	command -v 'terminator' &>/dev/null
}

util.if_file_sourced || _setup "$@"
