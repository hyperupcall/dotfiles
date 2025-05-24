#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='lefthook'

main() {
	helper.setup "$@"
}

install.any() {
	mise install lefthook@latest
	mise use -g lefthook@latest
}

installed() {
	command -v lefthook &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
