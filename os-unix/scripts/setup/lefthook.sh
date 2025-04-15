#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'lefthook' "$@"
}

install.any() {
	~/scripts/setup/go.sh

	go install github.com/evilmartians/lefthook@latest
}

installed() {
	command -v lefthook &>/dev/null
}

util.if_file_sourced || main "$@"
