#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-polyglot'
declare -g g_dir="$HOME/.dotfiles/.data/repos/polyglot"

main() {
	util.clone "$g_dir" 'https://github.com/agkozak/polyglot'
}

launch() {
	cat "$g_dir/polyglot.sh"
}

util.if_file_sourced || _setup "$@"
