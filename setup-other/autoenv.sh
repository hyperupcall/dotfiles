#!/usr/bin/env zsh
source ~/.dotfiles/config/setup.sh

declare -g g_name='autoenv'
declare -g g_dir="$HOME/.dotfiles/.data/repos/autoenv"

install.any() {
	util.clone "$g_dir" git@github.com:hyperupcall/autoenv
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_shellfile 'autoenv' \
		--sh '
			AUTOENV_PRESERVE_CD=yes
			. ~/.dotfiles/.data/repos/autoenv/activate.sh
			unset -v AUTOENV_PRESERVE_CD' \
		--bash '
			AUTOENV_PRESERVE_CD=yes . ~/.dotfiles/.data/repos/autoenv/activate.sh' \
		--zsh '
			AUTOENV_PRESERVE_CD=yes. ~/.dotfiles/.data/repos/autoenv/activate.sh'
}

util.if_file_sourced || _setup "$@"
