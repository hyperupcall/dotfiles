#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='pure'
declare -g g_dir="$HOME/.dotfiles/.data/repos/pure"

install.any() {
	util.clone "$g_dir" 'https://github.com/sindresorhus/pure'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'pure' \
		--zsh "
			fpath+=('$g_dir')
			autoload -Uz promptinit
			promptinit
			prompt pure"
}

util.if_file_sourced || _setup "$@"
