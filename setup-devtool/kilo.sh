#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Kilo'

install.any() {
	curl -K "$CURL_CONFIG" https://kilo.ai/cli/install | bash -s -- --no-modify-path
}

install.installed() {
	command -v kilo &>/dev/null
}

install.configure() {
	util.write_shellfile 'kilo' \
		--sh 'export PATH="$HOME/.kilo/bin:$PATH"' \
		--bash 'export PATH="$HOME/.kilo/bin:$PATH"' \
		--zsh 'export PATH="$HOME/.kilo/bin:$PATH"' \
		--fish 'fish_add_path "$HOME/.kilo/bin"'
}

util.if_file_sourced || _setup "$@"
