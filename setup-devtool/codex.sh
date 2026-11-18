#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Codex'

install.any() {
	curl -K "$CURL_CONFIG" https://chatgpt.com/codex/install.sh \
		| CODEX_NON_INTERACTIVE=1 PATH="$HOME/.local/bin:$PATH" sh
}

install.installed() {
	command -v codex &>/dev/null
}

util.if_file_sourced || _setup "$@"
