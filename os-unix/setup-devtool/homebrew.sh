#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Homebrew'

main() {
	bash -c "$(curl -K "$CURL_CONFIG" https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	brew install --cask font-0xproto-nerd-font # TODO
}

installed() {
	command -v brew &>/dev/null
}

util.if_file_sourced || _main "$@"
