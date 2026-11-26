#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='ls-lint'

install.any() {
	util.get_latest_github_release 'loeffel-io/ls-lint'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./ls-lint.tar.gz "https://github.com/loeffel-io/ls-lint/releases/download/$version/ls-lint-linux-amd64.tar.gz"
	tar xf ./ls-lint.tar.gz

	install -Dm755 ./ls-lint-linux-amd64 ~/.local/bin/ls-lint
}

install.installed() {
	command -v ls-lint &>/dev/null
}

util.if_file_sourced || _setup "$@"
