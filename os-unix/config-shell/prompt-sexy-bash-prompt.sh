#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-sexy-bash-prompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/sexy-bash-prompt"

install.any() {
	util.clone "$g_dir" 'https://github.com/twolfson/sexy-bash-prompt'
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_promptfile 'sexy-bash-prompt' \
		--bash "$(<"$g_dir/.bash_prompt")"
}

util.if_file_sourced || _setup "$@"
