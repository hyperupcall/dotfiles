#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='starship'

install.any() {
	cargo install starship
}

installed() {
	command -v starship &>/dev/null
}

configure() {
	util.write_promptfile 'starship' \
		--bash "$(starship init bash --print-full-init)" \
		--zsh "$(starship init zsh --print-full-init)"
}

util.if_file_sourced || _setup "$@"
