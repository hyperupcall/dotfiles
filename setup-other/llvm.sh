#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='LLVM'

install.debian() {
	sudo apt-get install -y clang clangd clang-format clang-tidy
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	command -v clang &>/dev/null && command -v clangd &>/dev/null && command -v clang-format &>/dev/null && command -v clang-tidy &>/dev/null
}

util.if_file_sourced || _setup "$@"
