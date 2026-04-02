#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

main() {
	util.install_by_setup_distro_package 'Alacritty' 'alacritty' 'alacritty' "$@"
}

util.if_file_sourced || _main "$@"
