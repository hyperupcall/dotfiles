#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Conan'

install.any() {
	pipx ensurepath
	pipx install conan
}

installed() {
	command -v conan &>/dev/null
}

util.if_file_sourced || _setup "$@"
