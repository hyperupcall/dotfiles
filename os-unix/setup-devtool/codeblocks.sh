#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Code::Blocks'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	sudo add-apt-repository -y ppa:x-psoud/cbreleases
	sudo apt-get update -y
	sudo apt-get install -y codeblocks
}

installed() {
	command -v codeblocks &>/dev/null
}

util.if_file_sourced || _setup "$@"
