#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Strix'

install.any() {
	# Set PATH so installer does not manipulate PATH in shell rc files.
	curl -K "$CURL_CONFIG" https://strix.ai/install | \
		PATH="$HOME/.strix/bin:$PATH" bash
}

install.installed() {
	command -v strix &>/dev/null || [ -x "$HOME/.strix/bin/strix" ]
}

install.configure() {
	util.write_shellfile 'strix' \
		--sh 'export PATH="$HOME/.strix/bin:$PATH"' \
		--bash 'export PATH="$HOME/.strix/bin:$PATH"' \
		--zsh 'export PATH="$HOME/.strix/bin:$PATH"' \
		--fish 'fish_add_path "$HOME/.strix/bin"'
}

util.if_file_sourced || _setup "$@"
