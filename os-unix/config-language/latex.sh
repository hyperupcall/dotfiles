#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='LaTeX (Tex Live)'

main() {
	util.install_by_setup "$@"
	cargo install --locked tex-fmt
}

install.debian() {
	sudo apt-get -y install texlive-full
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	command -v pdftex &>/dev/null && command -v tex-fmt &>/dev/null
}

util.if_file_sourced || _setup "$@"
