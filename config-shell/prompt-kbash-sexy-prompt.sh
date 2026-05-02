#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='kbash-sexy-prompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kbash-sexy-prompt"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kbash-sexy-prompt'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'kbash-sexy-prompt' \
		--bash "$(<"$g_dir/.bash_prompt")"
}

util.if_file_sourced || _setup "$@"
