#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-liquidprompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/liquidprompt"

main() {
	util.clone "$g_dir" 'https://github.com/nojhan/liquidprompt'
}

launch() {
	cat "$g_dir/liquidprompt"
}

util.if_file_sourced || _setup "$@"
