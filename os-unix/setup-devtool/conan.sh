#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='Conan'

main() {
	pipx ensurepath
	pipx install conan
}

installed() {
	command -v conan &>/dev/null
}

util.if_file_sourced || _setup "$@"
