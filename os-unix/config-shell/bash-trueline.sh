#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-trueline'
declare -g dir="$HOME/.dotfiles/.data/repos/trueline"

main() {
	helper.setup_gitrepo 'https://github.com/petobens/trueline' "$dir"
}

launch() {
	cat "$dir/trueline.sh"
}

util.if_file_sourced || _main "$@"
