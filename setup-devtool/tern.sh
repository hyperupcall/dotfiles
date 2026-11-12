#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Tern'

install.any() {
	curl -K "$CURL_CONFIG" https://tern.sh/install | bash
}

install.installed() {
	command -v tern &>/dev/null || [ -x "$HOME/.tern/bin/tern" ]
}

install.configure() {
	util.write_shellfile 'tern' \
		--sh 'export PATH="$HOME/.tern/bin:$PATH"' \
		--bash 'export PATH="$HOME/.tern/bin:$PATH"' \
		--zsh 'export PATH="$HOME/.tern/bin:$PATH"' \
		--fish 'fish_add_path "$HOME/.tern/bin"'
}

util.if_file_sourced || _setup "$@"
