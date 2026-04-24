#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='bash-sbp'
declare -g g_dir="$HOME/.dotfiles/.data/repos/ksbp"

install.any() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/ksbp'
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_promptfile 'ksbp' \
		--bash "
			SBP_PATH=\"$g_dir\"
			source \$SBP_PATH/sbp.bash"
}

util.if_file_sourced || _setup "$@"
