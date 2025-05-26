#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='xterm'
declare -g dir="$HOME/.dotfiles/.data/repos/bash-git-prompt"

main() {
	helper.setup_gitrepo 'https://github.com/magicmonty/bash-git-prompt' "$dir"
}

launch() { # TODO
	printf '%s\n' "__GIT_PROMPT_DIR=\"$dir\""
	cat "$dir/gitprompt.sh"
}

util.if_file_sourced || _main "$@"
