#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Python Tools'

main() {
	: # TODO
}

configure() {
	util.write_shellfile 'zoxide' \
		--bash 'eval "$(zoxide init bash)"' \
		--zsh 'eval "$(zoxide init zsh)"' \
		--sh 'eval "$(zoxide init posix --hook prompt)"' \
		--fish 'zoxide init fish | source' \
		--elvish 'eval (zoxide init elvish | slurp)'
}

util.if_file_sourced || _setup "$@"
