#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='rxvt'

main() {
	util.install_by_setup_distro_package 'rxvt' 'rxvt' 'rxvt' "$@"
}

util.if_file_sourced || _main "$@"
