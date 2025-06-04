#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='bash-pista'

main() {
	cargo install pista
}

launch() {
	printf '%s\n' "PS1='$(pista -m)'"
}

util.if_file_sourced || _setup "$@"
