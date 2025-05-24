#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='git-split-diffs'

main() {
	helper.setup "$@"
}

install.any() {
	pnpm install -g git-split-diffs
}

installed() {
	command -v git-split-diffs &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
