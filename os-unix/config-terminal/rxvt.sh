#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='rxvt'

main() {
	util.install_by_setup_distro_package 'rxvt' 'rxvt'
}

installed() {
	command -v 'rxvt' &>/dev/null
}

util.if_file_sourced || _setup "$@"
