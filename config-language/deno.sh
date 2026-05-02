#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Deno'

install.any() {
	curl -K "$CURL_CONFIG" https://deno.land/install.sh | DENO_INSTALL="$PWD" sh
}

install.installed() {
	command -v deno &>/dev/null
}

util.if_file_sourced || _setup "$@"
