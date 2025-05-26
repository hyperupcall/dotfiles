#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-pureline'
declare -g dir="$HOME/.dotfiles/.data/repos/pureline"

main() {
	helper.setup_gitrepo 'https://github.com/chris-marsh/pureline' "$dir"
}

launch() {
	cat "$dir/pureline"
}

util.if_file_sourced || _main "$@"
