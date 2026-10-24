#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Ollama'

install.any() {
	curl -K "$CURL_CONFIG" https://llama.app/install.sh | sh
}

install.installed() {
	command -v ollama &>/dev/null
}

util.if_file_sourced || _setup "$@"
