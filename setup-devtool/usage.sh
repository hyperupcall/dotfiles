#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='usage'

install.any() {
	util.get_latest_github_release 'jdx/usage'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o 'usage.tar.gz' \
		"https://github.com/jdx/usage/releases/download/$version/usage-x86_64-unknown-linux-musl.tar.gz"
	tar xf 'usage.tar.gz'

	mv './usage' ~/.local/bin/
	mv './usage.1' "$XDG_DATA_HOME/man/man1"
}

install.installed() {
	command -v usage &>/dev/null
}

util.if_file_sourced || _setup "$@"
