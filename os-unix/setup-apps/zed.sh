#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Zed'

main() {
	curl -K "$CURL_CONFIG" https://zed.dev/install.sh | sh
}

installed() {
	if command -v zed &>/dev/null && zed --version &>/dev/null; then
		local output=
		output=$(zed --version)
		[[ $output == 'Zed '* ]]
	fi
}

util.if_file_sourced || _setup "$@"
