#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='kpolyglot'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kpolyglot"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kpolyglot'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'kpolyglot' \
		--bash "$(<"$g_dir/polyglot.sh")"
}

util.if_file_sourced || _setup "$@"
