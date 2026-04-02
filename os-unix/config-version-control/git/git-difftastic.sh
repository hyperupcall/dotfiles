#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='difftastic'

install.any() {
	cargo install --force difftastic
}

installed() {
	command -v difft &>/dev/null
}

util.if_file_sourced || _setup "$@"
