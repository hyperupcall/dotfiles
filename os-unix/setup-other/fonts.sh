#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Docker'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	sudo add-apt-repository -y multiverse
	sudo apt-get update -y
	sudo apt-get install -y ttf-mscorefonts-installer
	sudo fc-cache -fv
}

installed() {
	fc-list | grep -q 'Times New Roman'
}

util.if_file_sourced || _setup "$@"
