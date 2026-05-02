#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='kbash-pureline'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kbash-pureline"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kbash-pureline'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'kbash-pureline' \
		--bash "$(<"$g_dir/pureline")"
}

util.if_file_sourced || _setup "$@"
