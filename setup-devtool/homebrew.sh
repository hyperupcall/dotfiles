#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Homebrew'

install.any() {
	bash -c "$(curl -K "$CURL_CONFIG" https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install.installed() {
	[ -x /home/linuxbrew/.linuxbrew/bin/brew ]
}

install.configure() {
	util.write_shellfile 'homebrew' \
		--sh 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' \
		--bash 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' \
		--zsh 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
}

util.if_file_sourced || _setup "$@"
