#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='diffr'

main() {
	helper.setup "$@"
}

install.any() {
	cargo install --force diffr
}

installed() {
	command -v diffr &>/dev/null
}

util.if_file_sourced || _main "$@"
