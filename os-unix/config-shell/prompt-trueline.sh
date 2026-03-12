#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-trueline'
declare -g g_dir="$HOME/.dotfiles/.data/repos/trueline"

main() {
	util.clone "$g_dir" 'https://github.com/petobens/trueline'
}

configure() {
	util.write_promptfile 'trueline' \
		--bash "$(<"$g_dir/trueline.sh")"
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
