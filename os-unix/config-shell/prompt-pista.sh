#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-pista'

main() {
	cargo install pista
}

configure() {
	util.write_promptfile 'pista' \
		--bash "PS1='$(pista -m)'"
}

installed() {
	command -v pista &>/dev/null
}

util.if_file_sourced || _setup "$@"
