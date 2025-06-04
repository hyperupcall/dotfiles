#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='pre-commit'

main() {
	pipx install pre-commit
}

installed() {
	command -v pre-commit &>/dev/null
}

util.if_file_sourced || _setup "$@"
