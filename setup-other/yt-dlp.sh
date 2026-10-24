#!/usr/bin/env zsh
source ~/.dotfiles/config/setup.sh

declare -g g_name='yt-dlp'

install.any() {
	util.get_latest_github_release 'yt-dlp/yt-dlp'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ~/.local/bin/yt-dlp "https://github.com/yt-dlp/yt-dlp/releases/download/$version/yt-dlp"
	chmod +x ~/.local/bin/yt-dlp
}

install.installed() {
	command -v yt-dlp &>/dev/null || return 1

	local output=
	output=$(yt-dlp --version 2>&1)
	if [ -z "$output" ] || [[ $output == *'out of date'* ]]; then
		return 1
	fi
}

util.if_file_sourced || _setup "$@"
