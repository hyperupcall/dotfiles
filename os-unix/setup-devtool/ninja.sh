#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='Ninja'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	sudo apt-get -y install ninja-build
}

installed() {
	command -v &>/dev/null ninja
}

util.if_file_sourced || _setup "$@"
