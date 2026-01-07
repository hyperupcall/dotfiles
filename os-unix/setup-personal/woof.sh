#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='Woof'

main() {
	basalt global add version-manager/woof
}

installed() {
	command -v woof &>/dev/null
}

configure() {
	util.write_shellfile 'woof' \
		--bash 'eval "$(woof init --no-cd bash)"' \
		--zsh 'eval "$(woof init --no-cd zsh)"'
}

util.if_file_sourced || _setup "$@"
