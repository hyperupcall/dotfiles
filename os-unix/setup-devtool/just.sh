#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='just'

main() {
	cargo install --locked just
}

installed() {
	command -v just &>/dev/null
}

util.if_file_sourced || _setup "$@"
