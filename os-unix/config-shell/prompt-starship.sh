#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='starship'

main() {
	cargo install starship
}

configure() {
	util.write_promptfile 'starship' \
		--bash "$(starship init bash --print-full-init)" \
		--zsh "$(starship init zsh --print-full-init)"
}

installed() {
	command -v starship &>/dev/null
}

util.if_file_sourced || _setup "$@"
