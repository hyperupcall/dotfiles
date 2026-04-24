#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='uv'

install.any() {
	curl -K "$CURL_CONFIG" https://astral.sh/uv/install.sh | sh
}

installed() {
	command -v uv &>/dev/null
}

util.if_file_sourced || _setup "$@"
