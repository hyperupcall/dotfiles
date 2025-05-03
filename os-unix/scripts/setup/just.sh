#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'just' "$@"
}

install.any() {
	cargo install --locked just
}

installed() {
	command -v just &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
