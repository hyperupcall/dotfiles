#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Spyder'

install.any() {
	util.get_latest_github_tag 'spyder-ide/spyder'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o Spyder-Linux-x86_64.sh "https://github.com/spyder-ide/spyder/releases/download/$version/Spyder-Linux-x86_64.sh"
	chmod +x Spyder-Linux-x86_64.sh
	./Spyder-Linux-x86_64.sh -p "$XDG_STATE_HOME/spyder-6"
}

installed() {
	[ -d "$XDG_STATE_HOME/spyder-6" ]
}

util.if_file_sourced || _setup "$@"
