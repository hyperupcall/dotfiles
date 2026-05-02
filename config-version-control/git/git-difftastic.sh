#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='difftastic'

install.any() {
	cargo install --force difftastic
}

install.installed() {
	command -v difft &>/dev/null
}

util.if_file_sourced || _setup "$@"
