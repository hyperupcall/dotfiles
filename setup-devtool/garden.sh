#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Garden'

install.any() {
	cargo install garden-tools garden-gui
}

installed() {
	command -v 'garden' &>/dev/null
}

util.if_file_sourced || _setup "$@"
