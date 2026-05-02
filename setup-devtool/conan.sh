#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Conan'

install.any() {
	pipx ensurepath
	pipx install conan
}

install.installed() {
	command -v conan &>/dev/null
}

util.if_file_sourced || _setup "$@"
