#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'My tools' "$@"
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

util.if_file_sourced || main "$@"
