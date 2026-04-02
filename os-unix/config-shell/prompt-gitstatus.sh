#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-gitstatus'
declare -g g_dir="$HOME/.dotfiles/.data/repos/gitstatus"

install.any() {
	util.clone "$g_dir" 'https://github.com/romkatv/gitstatus'
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_promptfile 'gitstatus' \
		--bash "
			export GITSTATUS_DIR=\"$g_dir/gitstatus.plugin.sh\"
			$(<"$g_dir/gitstatus.prompt.sh")"
}

util.if_file_sourced || _setup "$@"
