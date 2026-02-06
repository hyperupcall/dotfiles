#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Garden'

main() {
	cargo install garden-tools garden-gui
}

installed() {
	command -v 'garden' &>/dev/null
}

util.if_file_sourced || _setup "$@"
