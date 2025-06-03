#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Mise'

main() {
	curl -K "$CURL_CONFIG" https://mise.jdx.dev/install.sh | sh
}

configure() {
	util.write_shellfile 'mise' \
		--bash 'eval "$("$HOME/.local/bin/mise" activate bash)"' \
		--zsh 'eval "$("$HOME/.local/bin/mise" activate zsh)"'

}

installed() {
	command -v mise &>/dev/null
}

util.if_file_sourced || _main "$@"
