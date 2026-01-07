#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='bash-pureline'
declare -g g_dir="$HOME/.dotfiles/.data/repos/pureline"

main() {
	util.clone "$g_dir" 'https://github.com/chris-marsh/pureline'
}

launch() {
	cat "$g_dir/pureline"
}

util.if_file_sourced || _setup "$@"
