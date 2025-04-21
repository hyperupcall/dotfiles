#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'bats' "$@"
}

install.any() {
	local dir="$HOME/.dotfiles/.data/repos/bash-core"
	util.clone "$dir" https://github.com/bats-core/bats-core.git
	cd "$dir"
	sudo ./install.sh /usr/local
}

installed() {
	command -v bats &>/dev/null
}

util.if_file_sourced || main "$@"
