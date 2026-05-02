#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Mise'

install.any() {
	curl -K "$CURL_CONFIG" https://mise.jdx.dev/install.sh | sh

	if ! mise trust --cd ~/.dotfiles --show mise | grep -q '~/.dotfiles: trusted'; then
		if ! output=$(mise trust ~/.dotfiles/.mise.toml 2>&1); then
			printf '%s\n' "$output"
		fi
	fi

	eval "$("$HOME/.local/bin/mise" activate bash)"

	# TODO(2026.8.0): precompiled ruby will be the default on this day
	mise settings ruby.compile=false
	mise -C ~/.dotfiles install
	mise use -g node python cmake go
}

install.installed() {
	command -v mise &>/dev/null
}

install.configure() {
	util.write_shellfile '10-mise' \
		--bash 'eval "$("$HOME/.local/bin/mise" activate bash)"' \
		--zsh 'eval "$("$HOME/.local/bin/mise" activate zsh)"' \
		--fish 'eval "$("$HOME/.local/bin/mise" activate fish)"'
}

util.if_file_sourced || _setup "$@"
