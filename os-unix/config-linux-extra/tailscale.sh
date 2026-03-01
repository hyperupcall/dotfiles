#!/usr/bin/env zsh
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='tailscale'

main() {
	util.install_by_setup "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://tailscale.com/install.sh | sh
}

installed() {
	command -v tailscale &>/dev/null
}

util.if_file_sourced || _setup "$@"
