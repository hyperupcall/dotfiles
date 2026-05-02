#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='NodeJS'

install.installed() {
	command -v node &>/dev/null
}

install.configure() {
	util.write_shellfile 'nodejs' \
		--bash 'source <(node --completion-bash)'
}

util.if_file_sourced || _setup "$@"
