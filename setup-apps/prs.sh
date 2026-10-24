#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='prs'

install.any() {
	util.get_latest_github_release 'timvisee/prs'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./prs "https://github.com/timvisee/prs/releases/download/$version/prs-${version}-linux-x64"
	chmod +x ./prs
	mv ./prs ~/.local/bin/prs
}

install.installed() {
	command -v prs &>/dev/null
}

util.if_file_sourced || _setup "$@"
