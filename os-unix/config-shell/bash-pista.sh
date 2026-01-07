#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='bash-pista'

main() {
	cargo install pista
}

launch() {
	printf '%s\n' "PS1='$(pista -m)'"
}

util.if_file_sourced || _setup "$@"
