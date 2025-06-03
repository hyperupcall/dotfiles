#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Deno'

main() {
	curl -K "$CURL_CONFIG" https://deno.land/install.sh | DENO_INSTALL="$PWD" sh
}

installed() {
	command -v deno
}

util.if_file_sourced || _main "$@"
