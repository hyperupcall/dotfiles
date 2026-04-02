#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='LaTeX (Tex Live)'

install.debian() {
	sudo apt-get -y install texlive-full
	install_textfmt
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	command -v pdftex &>/dev/null && command -v tex-fmt &>/dev/null
}

install_textfmt() {
	cargo install --locked tex-fmt
}

util.if_file_sourced || _setup "$@"
