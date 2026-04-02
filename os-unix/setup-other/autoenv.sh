#!/usr/bin/env zsh
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='autoenv'
declare -g g_dir="$HOME/.dotfiles/.data/repos/autoenv"

install.any() {
	util.clone "$g_dir" git@github.com:hyperupcall/autoenv
}

installed() {
	[ -d "$g_dir" ]
}

configure() {
	util.write_shellfile 'autoenv' \
		--sh \
	'AUTOENV_PRESERVE_CD=yes
	. ~/.dotfiles/.data/repos/autoenv/activate.sh
	unset -v AUTOENV_PRESERVE_CD'
}

util.if_file_sourced || _setup "$@"
