#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

main() {
	util.install_by_setup_distro_package 'Zsh' 'zsh' 'zsh' "$@"
}

util.if_file_sourced || _main "$@"
