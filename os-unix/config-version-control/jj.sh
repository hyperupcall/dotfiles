#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='jj'

main() {
	helper.setup "$@"
}

install.any() {
	~/scripts/setup/rust.sh --no-confirm
	cargo binstall --strategies crate-meta-data jj-cli
}

installed() {
	command -v jj &>/dev/null
}

util.if_file_sourced || _main "$@"
