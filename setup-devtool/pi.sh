#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Pi'

install.any() {
	curl -K "$CURL_CONFIG" https://pi.dev/install.sh | sh
}

install.installed() {
	command -v pi &>/dev/null
}

util.if_file_sourced || _setup "$@"
