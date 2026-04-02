#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='bash-polyglot'
declare -g g_dir="$HOME/.dotfiles/.data/repos/polyglot"

install.any() {
	util.clone "$g_dir" 'https://github.com/agkozak/polyglot'
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_promptfile 'polyglot' \
		--bash "$(<"$g_dir/polyglot.sh")"
}

util.if_file_sourced || _setup "$@"
