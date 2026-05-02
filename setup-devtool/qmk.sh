#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='qmk'

install.any() {
	curl -K "$CURL_CONFIG" https://install.qmk.fm | sh
}

install.installed() {
	command -v qmk &>/dev/null
}

util.if_file_sourced || _setup "$@"
