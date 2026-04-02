#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-pista'

install.any() {
	cargo install pista
}

installed() {
	command -v pista &>/dev/null
}

configure() {
	util.write_promptfile 'pista' \
		--bash "PS1='$(pista -m)'"
}

util.if_file_sourced || _setup "$@"
