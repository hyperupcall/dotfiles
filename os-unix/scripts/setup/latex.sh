#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'LaTeX (Tex Live)' "$@"

	if ! command -v tex-fmt >/dev/null; then
		if command -v cargo >/dev/null; then
			cargo install tex-fmt
		else
			core.print_warn "Skipping install of tex-fmt since cargo not installed"
		fi
	fi
}

install.debian() {
	sudo apt-get -y install texlive-full
}

installed() {
	command -v pdftex &>/dev/null && command -v tex-fmt &>/dev/null
}

util.if_file_sourced || main "$@"
