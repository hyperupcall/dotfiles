#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='yq'

install.any() {
	util.get_latest_github_release 'mikefarah/yq'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./yq.tar.gz "https://github.com/mikefarah/yq/releases/download/$version/yq_linux_amd64.tar.gz"
	tar xf ./yq.tar.gz

	install -Dm755 ./yq_linux_amd64 ~/.local/bin/yq

	install -Dm644 yq.1 ~/.local/share/man/man1/yq.1
}

install.installed() {
	command -v yq &>/dev/null
}

util.if_file_sourced || _setup "$@"
