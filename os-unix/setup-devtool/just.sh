#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='just'

main() {
	helper.setup "$@"
}

install.any() {
	cargo install --locked just
}

installed() {
	command -v just &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
