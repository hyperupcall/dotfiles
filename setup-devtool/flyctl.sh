#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='flyctl'

install.any() {
	curl -K "$CURL_CONFIG" https://fly.io/install.sh | sh
}

install.installed() {
	command -v flyctl &>/dev/null
}

install.configure() {
	util.write_shellfile 'flyctl' \
		--sh 'export PATH="$HOME/.fly/bin:$PATH"' \
		--bash 'export PATH="$HOME/.fly/bin:$PATH"' \
		--zsh 'export PATH="$HOME/.fly/bin:$PATH"' \
		--fish 'fish_add_path "$HOME/.fly/bin"'
}

util.if_file_sourced || _setup "$@"
