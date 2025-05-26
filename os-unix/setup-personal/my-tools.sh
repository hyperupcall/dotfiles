#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='My tools'

main() {
	helper.setup "$@"
}

install.any() {
	if ! commaind -v cargo &>/dev/null; then
		~/scripts/setup/rust.sh
	fi

	cargo install fox-default
}

installed() {
	command -v default &>/dev/null
}

util.if_file_sourced || _main "$@"
