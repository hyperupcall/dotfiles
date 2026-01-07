#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='shfmt'

main() {
	util.get_latest_github_tag 'mvdan/sh'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./shfmt "https://github.com/mvdan/sh/releases/download/$version/shfmt_${version}_linux_amd64"
	chmod +x ./shfmt
	mv ./shfmt ~/.local/bin/shfmt
}

installed() {
	command -v shfmt &>/dev/null
}

util.if_file_sourced || _setup "$@"
