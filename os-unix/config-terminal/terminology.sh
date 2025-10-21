#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='terminology'

main() {
	util.install_by_setup_distro_package 'terminology' 'terminology'
}

installed() {
	command -v 'terminology' &>/dev/null
}

util.if_file_sourced || _setup "$@"
