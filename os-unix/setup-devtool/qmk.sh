#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='qmk'

install.any() {
	curl -fsSL https://install.qmk.fm | sh
}

installed() {
	command -v qmk &>/dev/null
}

util.if_file_sourced || _setup "$@"
