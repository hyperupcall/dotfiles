#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='pinact'

install.any() {
	util.get_latest_github_release 'suzuki-shunsuke/pinact'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./pinact.tar.gz "https://github.com/suzuki-shunsuke/pinact/releases/download/$version/pinact_linux_amd64.tar.gz"
	tar xf ./pinact.tar.gz

	install -Dm755 ./pinact ~/.local/bin/pinact
}

install.installed() {
	command -v pinact &>/dev/null
}

util.if_file_sourced || _setup "$@"
