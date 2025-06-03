#!/usr/bin/env zsh

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='yt-dlp'

main() {
	curl -K "$CURL_CONFIG" -o ~/.local/bin/yt-dlp 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'
	chmod +x ~/.local/bin/yt-dlp
}

util.if_file_sourced || _main "$@"
