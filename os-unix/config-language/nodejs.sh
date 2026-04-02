#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='NodeJS'

installed() {
	command -v node &>/dev/null
}

configure() {
	util.write_shellfile 'nodejs' \
		--bash 'source <(node --completion-bash)'
}

util.if_file_sourced || _setup "$@"
