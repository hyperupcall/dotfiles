#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-liquidprompt'
declare -g dir="$HOME/.dotfiles/.data/repos/liquidprompt"

main() {
	helper.setup_gitrepo 'https://github.com/nojhan/liquidprompt' "$dir"
}

launch() {
	cat "$dir/liquidprompt"
}

util.if_file_sourced || _main "$@"
