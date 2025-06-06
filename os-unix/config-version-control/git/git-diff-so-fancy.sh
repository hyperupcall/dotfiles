#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='diff-so-fancy'

main() {
	util.get_latest_github_tag 'so-fancy/diff-so-fancy'
	local latest_tag=$REPLY

	curl -K "$CURL_CONFIG" -o ~/.local/bin/diff-so-fancy "https://github.com/so-fancy/diff-so-fancy/releases/download/$latest_tag/diff-so-fancy"
	chmod +x ~/.local/bin/diff-so-fancy
}

installed() {
	command -v diff-so-fancy &>/dev/null
}

util.if_file_sourced || _setup "$@"
