#!/usr/bin/env zsh
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='tailscale'

install.any() {
	curl -K "$CURL_CONFIG" https://tailscale.com/install.sh | sh
}

installed() {
	command -v tailscale &>/dev/null
}

util.if_file_sourced || _setup "$@"
