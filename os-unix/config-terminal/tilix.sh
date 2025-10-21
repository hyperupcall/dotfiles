#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='tilix'

main() {
	util.install_by_setup_distro_package 'tilix' 'tilix'
}

installed() {
	command -v 'tilix' &>/dev/null
}

util.if_file_sourced || _setup "$@"
