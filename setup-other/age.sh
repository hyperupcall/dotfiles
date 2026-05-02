#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='age'

install.any() {
	util.get_latest_github_release 'FiloSottile/age'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o 'age.tar.gz' "https://github.com/FiloSottile/age/releases/download/$version/age-$version-linux-amd64.tar.gz"
	tar xf './age.tar.gz'

	mv './age/age' ~/.local/bin/
	mv './age/age-keygen' ~/.local/bin/
}

install.installed() {
	command -v age &>/dev/null && command -v age-keygen &>/dev/null
}

util.if_file_sourced || _setup "$@"
