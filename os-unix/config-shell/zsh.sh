#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='zsh'

main() {
	util.install_by_setup_distro_package 'zsh' 'zsh'
}

installed() {
	command -v 'zsh' &>/dev/null
}

util.if_file_sourced || _setup "$@"
