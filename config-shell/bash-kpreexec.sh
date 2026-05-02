#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='bash-preexec'
declare -g g_dir="$HOME/.dotfiles/.data/repos/kbash-preexec"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/kbash-preexec'
}

install.configure() {
	util.write_promptfile 'kbash-prexec' \
		--bash "
			if [ -d \"$g_dir\" ]; then
					source \"$g_dir/bash-preexec.sh\"
			else
					_util_log_warn 'Not sourcing rcaloras/bash-preexec'
			fi"
}

install.installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
