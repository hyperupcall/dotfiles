#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='sdkman'

install.any() {
	curl -K "$CURL_CONFIG" "https://get.sdkman.io" | bash
}

install.installed() {
	[ -d "${SDKMAN_DIR:-$HOME/.sdkman}" ]
}

install.configure() {
	util.write_shellfile 'sdkman' \
		--bash 'source "${SDKMAN_DIR:-$HOME/.sdkman}/bin/sdkman-init.sh"' \
		--zsh 'source "${SDKMAN_DIR:-$HOME/.sdkman}/bin/sdkman-init.sh"'
}

util.if_file_sourced || _setup "$@"
