#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Git Cola'

main() {
	util.install_by_setup_distro_package 'git-cola' 'git-cola'
}

installed() {
	command -v git-cola &>/dev/null
}

util.if_file_sourced || _setup "$@"
