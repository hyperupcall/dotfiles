#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='bats'

install.any() {
	local dir="$HOME/.dotfiles/.data/repos/bash-core"
	util.clone "$dir" https://github.com/bats-core/bats-core.git
	cd "$dir"
	sudo ./install.sh /usr/local
}

install.installed() {
	command -v bats &>/dev/null
}

util.if_file_sourced || _setup "$@"
