#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='just'

install.any() {
	cargo install --locked just
}

install.installed() {
	command -v just &>/dev/null
}

util.if_file_sourced || _setup "$@"
