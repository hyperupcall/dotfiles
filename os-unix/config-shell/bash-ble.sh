#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='bash-ble'
declare -g g_dir="$HOME/.dotfiles/.data/repos/bash-ble"

main() {
	util.clone "$g_dir" 'https://github.com/akinomyoga/ble.sh'
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
