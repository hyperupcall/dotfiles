#!/usr/bin/env zsh

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='autoenv'

main() {
	helper.setup "$@"
}

install.any() {
	local dir="$HOME/.dotfiles/.data/repos/autoenv"
	util.clone "$dir" git@github.com:hyperupcall/autoenv
}

configure() {
	util.write_shellfile 'autoenv' \
		--sh 'source ~/.dotfiles/.data/repos/autoenv/activate.sh'
}

util.if_file_sourced || _main "$@"
