#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Zed'

main() {
	helper.setup "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://zed.dev/install.sh | sh
}

util.if_file_sourced || helper.run_main "$@"
