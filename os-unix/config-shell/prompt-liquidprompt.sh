#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-liquidprompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/liquidprompt"

main() {
	util.clone "$g_dir" 'https://github.com/liquidprompt/liquidprompt'
}

configure() {
	util.write_promptfile 'liquidprompt' \
		--bash "$(<"$g_dir/liquidprompt")"
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
