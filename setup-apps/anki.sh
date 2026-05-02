#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Anki'

install.any() {
	# util.get_latest_github_release 'ankitects/anki'
	# local version="$REPLY"
	local version='25.09'
	core.print_warn "Anki version is hardcoded to $version"

	curl -K "$CURL_CONFIG" -o ./anki.tar.zst "https://github.com/ankitects/anki/releases/download/$version/anki-launcher-$version-linux.tar.zst"
	tar xf ./anki.tar.zst
	cd ./anki-launcher-*/
	sudo ./install.sh
}

install.installed() {
	command -v anki &>/dev/null
}

util.if_file_sourced || _setup "$@"
