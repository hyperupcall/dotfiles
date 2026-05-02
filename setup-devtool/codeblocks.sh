#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Code::Blocks'

install.ubuntu() {
	sudo add-apt-repository -y ppa:x-psoud/cbreleases
	sudo apt-get update -y
	sudo apt-get install -y codeblocks
}

install.installed() {
	command -v codeblocks &>/dev/null
}

util.if_file_sourced || _setup "$@"
