#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='Deno'

main() {
	curl -K "$CURL_CONFIG" https://deno.land/install.sh | DENO_INSTALL="$PWD" sh
}

installed() {
	command -v deno
}

util.if_file_sourced || _setup "$@"
