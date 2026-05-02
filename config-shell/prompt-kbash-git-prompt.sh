#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='kbash-git-prompt'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kbash-git-prompt"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kbash-git-prompt'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'kbash-git-prompt' \
		--bash "
			__GIT_PROMPT_DIR=\"$g_dir\"
			$(<"$g_dir/gitprompt.sh")"
}

util.if_file_sourced || _setup "$@"
