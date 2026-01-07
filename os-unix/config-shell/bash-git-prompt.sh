#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='xterm'
declare -g g_dir="$HOME/.dotfiles/.data/repos/bash-git-prompt"

main() {
	util.clone "$g_dir" 'https://github.com/magicmonty/bash-git-prompt'
}

launch() { # TODO
	printf '%s\n' "__GIT_PROMPT_DIR=\"$g_dir\""
	cat "$g_dir/gitprompt.sh"
}

util.if_file_sourced || _setup "$@"
