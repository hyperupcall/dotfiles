#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Deno'

install.any() {
	curl -K "$CURL_CONFIG" https://deno.land/install.sh | DENO_INSTALL="$PWD" sh
}

installed() {
	command -v deno &>/dev/null
}

util.if_file_sourced || _setup "$@"
