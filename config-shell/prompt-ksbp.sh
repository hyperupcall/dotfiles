#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='bash-ksbp'
declare -g g_dir="$HOME/.dotfiles/.data/repos/ksbp"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/ksbp'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_promptfile 'ksbp' \
		--bash "
			SBP_PATH=\"$g_dir\"
			source \$SBP_PATH/sbp.bash"
}

util.if_file_sourced || _setup "$@"
