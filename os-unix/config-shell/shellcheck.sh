#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='shellcheck'

install.any() {
	util.get_latest_github_tag 'koalaman/shellcheck'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./shellcheck.tar.xz "https://github.com/koalaman/shellcheck/releases/download/$version/shellcheck-$version.linux.x86_64.tar.xz"
	tar xf ./shellcheck.tar.xz
	cd ./shellcheck-v*/
	mv shellcheck ~/.local/bin/shellcheck
}

installed() {
	command -v shellcheck &>/dev/null
}

util.if_file_sourced || _setup "$@"
