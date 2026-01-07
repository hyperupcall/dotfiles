#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='xterm'

main() {
	util.install_by_setup_distro_package 'xterm' 'xterm'
}

installed() {
	command -v 'xterm' &>/dev/null
}

util.if_file_sourced || _setup "$@"
