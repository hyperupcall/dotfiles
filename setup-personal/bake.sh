#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Bake'

install.any() {
	util.get_latest_github_release 'hyperupcall/bake'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./bake https://raw.githubusercontent.com/hyperupcall/bake/main/bin/bake

	chmod +x ./bake
	mv ./bake ~/.local/bin/bake
}

install.installed() {
	command -v bake &>/dev/null
}

util.if_file_sourced || _setup "$@"
