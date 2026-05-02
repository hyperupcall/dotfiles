#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='passage'
declare -g g_dir="$HOME/.dotfiles/.data/repos/passage"

install.any() {
	util.clone "$g_dir" https://github.com/FiloSottile/passage.git
	cd "$g_dir"

	sudo make install PREFIX=/usr/local
}

install.installed() {
	command -v passage &>/dev/null
}

util.if_file_sourced || _setup "$@"
