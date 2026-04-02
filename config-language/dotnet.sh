#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Dotnet'

install.ubuntu() {
	# TODO
	sudo add-apt-repository -y 'ppa:dotnet/backports'
}

installed() {
	command -v dotnet &>/dev/null
}

util.if_file_sourced || _setup "$@"
