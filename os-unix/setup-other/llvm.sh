#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='LLVM'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	sudo apt-get install -y clang clang-format clang-tidy
}

install.ubuntu() {
	install.debuan "$@"
}

installed() {
	command -v clang &>/dev/null && command -v clang-format &>/dev/null && command -v clang-tidy &>/dev/null
}

util.if_file_sourced || _setup "$@"
