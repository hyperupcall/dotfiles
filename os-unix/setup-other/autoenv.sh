#!/usr/bin/env zsh
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='autoenv'
declare -g g_dir="$HOME/.dotfiles/.data/repos/autoenv"

main() {
	util.clone "$g_dir" git@github.com:hyperupcall/autoenv
}

configure() {
	util.write_shellfile 'autoenv' \
		--sh \
	'AUTOENV_PRESERVE_CD=yes
	. ~/.dotfiles/.data/repos/autoenv/activate.sh
	unset -v AUTOENV_PRESERVE_CD'
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
