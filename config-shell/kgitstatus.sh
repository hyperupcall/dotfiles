#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='kgitstatus'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kgitstatus"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kgitstatus'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'kgitstatus' \
		--bash "
			export GITSTATUS_DIR=\"$g_dir/gitstatus.plugin.sh\"
			$(<"$g_dir/gitstatus.prompt.sh")"
}

util.if_file_sourced || _setup "$@"
