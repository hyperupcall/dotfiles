#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='bash-ble'
declare -g g_dir="$HOME/.dotfiles/.data/repos/bash-ble"

install.any() {
	util.clone "$g_dir" 'https://github.com/akinomyoga/ble.sh'
	make -C "$g_dir"
}

install.configure() {
	util.write_shellfile 'ble' \
		--bash "
			source \"$g_dir/out/ble.sh\""
}

install.installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
