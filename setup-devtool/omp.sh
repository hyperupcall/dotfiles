#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='omp'

install.any() {
	curl -K "$CURL_CONFIG" https://omp.sh/install | sh
}

install.installed() {
	command -v omp &>/dev/null
}

util.if_file_sourced || _setup "$@"
