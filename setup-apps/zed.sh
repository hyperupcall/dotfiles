#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Zed'

install.any() {
	curl -K "$CURL_CONFIG" https://zed.dev/install.sh | sh
}

install.installed() {
	if ! command -v zed &>/dev/null; then
		return 1
	fi

	local output=
	output=$(zed --version)
	[[ $output == 'Zed '* ]]
}

util.if_file_sourced || _setup "$@"
