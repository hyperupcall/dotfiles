#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Anki'

install.any() {
	util.get_latest_github_tag 'ankitects/anki'
	local version="$REPLY"
	version='25.09' # TODO

	curl -K "$CURL_CONFIG" -o ./anki.tar.zst "https://github.com/ankitects/anki/releases/download/$version/anki-launcher-$version-linux.tar.zst"
	tar xf ./anki.tar.zst
	cd ./anki-launcher-*/
	sudo ./install.sh
}

installed() {
	command -v anki &>/dev/null
}

util.if_file_sourced || _setup "$@"
