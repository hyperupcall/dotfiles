#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='konsole'

main() {
	util.install_by_setup_distro_package 'konsole' 'konsole'
}

installed() {
	command -v 'konsole' &>/dev/null
}

util.if_file_sourced || _setup "$@"
