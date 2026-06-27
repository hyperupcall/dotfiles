#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Hugo'

install.any() {
	util.get_latest_github_release 'gohugoio/hugo'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./hugo.tar.gz "https://github.com/gohugoio/hugo/releases/download/$version/hugo_${version#v}_linux-amd64.tar.gz"
	tar xf ./hugo.tar.gz

	mv ./hugo ~/.local/bin
}

install.installed() {
	command -v hugo &>/dev/null
}

util.if_file_sourced || _setup "$@"
