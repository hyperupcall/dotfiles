#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='starship'

main() {
	cargo install starship
}

launch() {
	starship init bash --print-full-init
}

util.if_file_sourced || _setup "$@"
