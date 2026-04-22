#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Mise'

install.any() {
	curl -K "$CURL_CONFIG" https://mise.jdx.dev/install.sh | sh

	mise -C ~/.dotfiles install
	mise install node@25 python@3.14
	mise use -g node@25 python@3.14
}

installed() {
	command -v mise &>/dev/null
}

configure() {
	util.write_shellfile 'mise' \
		--bash 'eval "$("$HOME/.local/bin/mise" activate bash)"' \
		--zsh 'eval "$("$HOME/.local/bin/mise" activate zsh)"' \
		--fish 'eval "$("$HOME/.local/bin/mise" activate fish)"'
}

util.if_file_sourced || _setup "$@"
