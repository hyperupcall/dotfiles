#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='pre-commit'

install.any() {
	pipx install pre-commit
}

installed() {
	command -v pre-commit &>/dev/null
}

util.if_file_sourced || _setup "$@"
