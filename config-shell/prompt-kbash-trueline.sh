#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='kbash-trueline'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kbash-trueline"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kbash-trueline'
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_promptfile 'kbash-trueline' \
		--bash "$(<"$g_dir/trueline.sh")"
}

util.if_file_sourced || _setup "$@"
