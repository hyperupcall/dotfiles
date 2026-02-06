#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='NodeJS'

configure() {
	util.write_shellfile 'nodejs' \
		--bash 'source <(node --completion-bash)'
}

util.if_file_sourced || _setup "$@"
