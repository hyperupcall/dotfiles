#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='alacritty'

main() {
	util.install_by_setup_distro_package 'alacritty' 'alacritty'
}

installed() {
	command -v 'alacritty' &>/dev/null
}

util.if_file_sourced || _setup "$@"
