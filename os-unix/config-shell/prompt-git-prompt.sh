#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='xterm'
declare -g g_dir="$HOME/.dotfiles/.data/repos/bash-git-prompt"

main() {
	util.clone "$g_dir" 'https://github.com/magicmonty/bash-git-prompt'
}

configure() {
	util.write_promptfile 'git-prompt' \
		--bash "
			__GIT_PROMPT_DIR=\"$g_dir\"
			$(<"$g_dir/gitprompt.sh")"
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
