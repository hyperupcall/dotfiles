#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='GHC'

install.any() {
	mkdir -p "$XDG_DATA_HOME/ghcup"
	ln -s "$XDG_DATA_HOME"/{,ghcup/.}ghcup

	curl -K "$CURL_CONFIG" 'https://get-ghcup.haskell.org' | sh
	curl -K "$CURL_CONFIG" 'https://get.haskellstack.org' | sh
}

install.installed() {
	command -v ghcup &>/dev/null && command -v stack &>/dev/null
}

util.if_file_sourced || _setup "$@"
