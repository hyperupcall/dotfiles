#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='dircolors'

main() {
	helper.setup "$@"
}

install.any() {
	:
}

configure() {
	util.write_shellfile 'pipx' \
		--bash 'eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"' \
		--zsh 'eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"' \
		--tcsh 'eval "$(dircolors -c "$XDG_CONFIG_HOME/dircolors/dir_colors")"'
}

util.if_file_sourced || _main "$@"
