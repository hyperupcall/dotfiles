#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-pureline'
declare -g g_dir="$HOME/.dotfiles/.data/repos/pureline"

install.any() {
	util.clone "$g_dir" 'https://github.com/chris-marsh/pureline'
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_promptfile 'pureline' \
		--bash "$(<"$g_dir/pureline")"
}

util.if_file_sourced || _setup "$@"
