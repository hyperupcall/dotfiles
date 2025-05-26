#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-sexy-bash-prompt'
declare -g dir="$HOME/.dotfiles/.data/repos/sexy-bash-prompt"

main() {
	helper.setup_gitrepo 'https://github.com/twolfson/sexy-bash-prompt' "$dir"
}

launch() {
	cat "$dir/.bash_prompt"
}

util.if_file_sourced || _main "$@"
