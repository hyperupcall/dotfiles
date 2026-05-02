#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='bash-liquidprompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/liquidprompt"

install.any() {
	util.clone "$g_dir" 'https://github.com/liquidprompt/liquidprompt'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'liquidprompt' \
		--bash "$(<"$g_dir/liquidprompt")"
}

util.if_file_sourced || _setup "$@"
