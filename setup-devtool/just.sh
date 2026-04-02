#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='just'

install.any() {
	cargo install --locked just
}

installed() {
	command -v just &>/dev/null
}

util.if_file_sourced || _setup "$@"
