#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='jj'

main() {
	~/scripts/setup/rust.sh --no-confirm
	cargo binstall --strategies crate-meta-data jj-cli
}

installed() {
	command -v jj &>/dev/null
}

util.if_file_sourced || _setup "$@"
