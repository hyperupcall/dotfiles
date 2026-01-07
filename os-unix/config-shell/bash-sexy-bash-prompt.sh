#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='bash-sexy-bash-prompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/sexy-bash-prompt"

main() {
	util.clone "$g_dir" 'https://github.com/twolfson/sexy-bash-prompt'
}

launch() {
	cat "$g_dir/.bash_prompt"
}

util.if_file_sourced || _setup "$@"
