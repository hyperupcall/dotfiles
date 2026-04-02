#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

main() {
	util.install_by_setup_distro_package 'Git Cola' 'git-cola' 'git-cola' "$@"
}

util.if_file_sourced || _main "$@"
