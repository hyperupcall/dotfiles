#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='sdkman'

install.any() {
	curl -K "$CURL_CONFIG" "https://get.sdkman.io" | bash
}

installed() {
	[ -d "${SDKMAN_DIR:-$HOME/.sdkman}" ]
}

configure() {
	util.write_shellfile 'sdkman' \
		--bash 'source "${SDKMAN_DIR:-$HOME/.sdkman}/bin/sdkman-init.sh"' \
		--zsh 'source "${SDKMAN_DIR:-$HOME/.sdkman}/bin/sdkman-init.sh"'
}

util.if_file_sourced || _setup "$@"
