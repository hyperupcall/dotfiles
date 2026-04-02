#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-git-prompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/bash-git-prompt"

install.any() {
	util.clone "$g_dir" 'https://github.com/magicmonty/bash-git-prompt'
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_promptfile 'git-prompt' \
		--bash "
			__GIT_PROMPT_DIR=\"$g_dir\"
			$(<"$g_dir/gitprompt.sh")"
}

util.if_file_sourced || _setup "$@"
