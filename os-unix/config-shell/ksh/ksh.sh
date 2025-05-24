#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='ksh'

main() {
	helper.setup "$@"
}

install.debian() {
	sudo apt-get install -y ksh
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf install -y ksh
}

install.opensuse() {
	sudo zypper -n install ksh
}

install.arch() {
	yay -Syu --noconfirm ksh
}

installed() {
	command -v ksh &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
