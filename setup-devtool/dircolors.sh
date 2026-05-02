#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='dircolors'

install.installed() {
	command -v dircolors &>/dev/null
}

install.configure() {
	util.write_shellfile 'dircolors' \
		--bash 'eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"' \
		--zsh 'eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"' \
		--tcsh 'eval "$(dircolors -c "$XDG_CONFIG_HOME/dircolors/dir_colors")"'
}

util.if_file_sourced || _setup "$@"
