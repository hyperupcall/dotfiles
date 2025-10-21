#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='kitty'

main() {
	util.install_by_setup_distro_package 'kitty' 'kitty'
}

installed() {
	command -v 'kitty' &>/dev/null
}

util.if_file_sourced || _setup "$@"
