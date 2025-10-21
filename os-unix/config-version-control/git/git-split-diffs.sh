#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='git-split-diffs'

main() {
	pnpm install -g git-split-diffs
}

installed() {
	command -v git-split-diffs &>/dev/null
}

util.if_file_sourced || _setup "$@"
