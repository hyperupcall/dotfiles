#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Mise' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://mise.jdx.dev/install.sh | sh
}

configure() {
	util.write_shellfile mise bash \
		'eval "$("$HOME/.local/bin/mise" activate bash)"'
	util.write_shellfile mise zsh \
		'eval "$("$HOME/.local/bin/mise" activate zsh)"'
}

installed() {
	command -v mise &>/dev/null
}

util.if_file_sourced || main "$@"
