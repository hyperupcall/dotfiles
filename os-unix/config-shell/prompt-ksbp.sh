#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-sbp'
declare -g g_dir="$HOME/.dotfiles/.data/repos/ksbp"

main() {
	util.clone "$g_dir" 'https://github.com/hyperupcall-projects/ksbp'
}

configure() {
	util.write_promptfile 'ksbp' \
		--bash "
			SBP_PATH=\"$g_dir\"
			source \$SBP_PATH/sbp.bash"
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
