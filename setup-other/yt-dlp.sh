#!/usr/bin/env zsh
source ~/.dotfiles/data/setup.sh

declare -g g_name='yt-dlp'

install.any() {
	curl -K "$CURL_CONFIG" -o ~/.local/bin/yt-dlp 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'
	chmod +x ~/.local/bin/yt-dlp
}

installed() {
	command -v yt-dlp &>/dev/null
}

util.if_file_sourced || _setup "$@"
