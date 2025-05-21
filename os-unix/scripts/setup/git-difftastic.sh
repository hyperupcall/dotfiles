#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='difftastic'

main() {
	helper.setup "$@"
}

install.any() {
	cargo install --force difftastic
}

installed() {
	command -v difft &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
