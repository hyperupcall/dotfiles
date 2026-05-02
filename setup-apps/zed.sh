#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Zed'

install.any() {
	curl -K "$CURL_CONFIG" https://zed.dev/install.sh | sh
}

install.installed() {
	if command -v zed &>/dev/null && zed --version &>/dev/null; then
		local output=
		output=$(zed --version)
		[[ $output == 'Zed '* ]]
	fi
}

util.if_file_sourced || _setup "$@"
