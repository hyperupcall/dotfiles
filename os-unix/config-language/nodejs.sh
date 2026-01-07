#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='NodeJS'

configure() {
	util.write_shellfile 'nodejs' \
		--bash 'source <(node --completion-bash)'
}

util.if_file_sourced || _setup "$@"
