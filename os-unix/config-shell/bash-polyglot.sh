#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-polyglot'
declare -g dir="$HOME/.dotfiles/.data/repos/polyglot"

main() {
	helper.setup_gitrepo 'https://github.com/agkozak/polyglot' "$dir"
}

launch() {
	cat "$dir/polyglot.sh"
}

util.if_file_sourced || _main "$@"
