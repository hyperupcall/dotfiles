#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Dotnet' "$@"
}

install.ubuntu() {
	sudo add-apt-repository -y 'ppa:dotnet/backports'
}

util.if_file_sourced || helper.run_main "$@"
