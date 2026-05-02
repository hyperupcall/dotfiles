#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='spaceship'
declare -g g_dir="$HOME/.dotfiles/.data/repos/spaceship"

install.any() {
	util.clone "$g_dir" 'https://github.com/spaceship-prompt/spaceship-prompt'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'spaceship' \
		--zsh "
			fpath+=('$g_dir')
			autoload -Uz promptinit
			promptinit
			prompt spaceship"
}

util.if_file_sourced || _setup "$@"
