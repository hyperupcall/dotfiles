#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

main() {
	util.install_by_setup_distro_package 'Terminator' 'terminator' 'terminator' "$@"
}

util.if_file_sourced || _main "$@"
