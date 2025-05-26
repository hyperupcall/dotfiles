#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='NodeJS'

main() {
	helper.setup "$@"
}

install.any() {
	:
}

configure() {
	util.write_shellfile 'pipx' \
		--bash 'source <(node --completion-bash)'
}

util.if_file_sourced || _main "$@"
