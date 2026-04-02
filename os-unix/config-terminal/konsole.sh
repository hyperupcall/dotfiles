#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

main() {
	util.install_by_setup_distro_package 'Konsole' 'konsole' 'konsole' "$@"
}

util.if_file_sourced || _main "$@"
