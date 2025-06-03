#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Poetry'

main() {
	curl -K "$CURL_CONFIG" https://install.python-poetry.org | python3 -
}

installed() {
	command -v poetry &>/dev/null
}

util.if_file_sourced || _main "$@"
