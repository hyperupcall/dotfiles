#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='zizmor'

install.any() {
	cargo install --locked zizmor
}

install.installed() {
	command -v zizmor &>/dev/null
}

util.if_file_sourced || _setup "$@"
