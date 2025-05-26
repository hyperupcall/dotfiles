#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Dotnet'

main() {
	helper.setup "$@"
}

install.ubuntu() {
	sudo add-apt-repository -y 'ppa:dotnet/backports'
}

util.if_file_sourced || helper.run_main "$@"
