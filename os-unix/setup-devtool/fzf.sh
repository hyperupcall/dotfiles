#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='fzf'

main() {
	util.install_by_setup_distro_package 'fzf' 'fzf'
}

installed() {
	command -v 'fzf' &>/dev/null
}

util.if_file_sourced || _setup "$@"
