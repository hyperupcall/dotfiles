#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Mise'

install.any() {
	curl -K "$CURL_CONFIG" https://mise.jdx.dev/install.sh | sh
}

installed() {
	command -v mise &>/dev/null
}

configure() {
	util.write_shellfile 'mise' \
		--bash 'eval "$("$HOME/.local/bin/mise" activate bash)"' \
		--zsh 'eval "$("$HOME/.local/bin/mise" activate zsh)"'
}

util.if_file_sourced || _setup "$@"
