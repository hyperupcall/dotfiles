#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='oh-my-posh'

install.any() {
	util.get_latest_github_release 'JanDeDobbeleer/oh-my-posh'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ~/.local/bin/oh-my-posh \
		"https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/$version/posh-linux-amd64"
	chmod +x ~/.local/bin/oh-my-posh
}

install.installed() {
	command -v oh-my-posh &>/dev/null
}

install.configure() {
	util.write_promptfile 'oh-my-posh' \
		--bash 'eval "$(oh-my-posh init bash)"' \
		--zsh 'eval "$(oh-my-posh init zsh)"' \
		--fish 'oh-my-posh init fish | source'
}

util.if_file_sourced || _setup "$@"
