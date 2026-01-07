#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='diffr'

main() {
	cargo install --force diffr
}

installed() {
	command -v diffr &>/dev/null
}

util.if_file_sourced || _setup "$@"
