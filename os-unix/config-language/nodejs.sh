#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='NodeJS'

main() {
	helper.setup "$@"
}

install.any() {
	: # TODO
}

configure() {
	util.write_shellfile 'nodejs' \
		--bash 'source <(node --completion-bash)'
}

util.if_file_sourced || _main "$@"
