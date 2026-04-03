#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='yq'

install.any() {
	util.get_latest_github_tag 'mikefarah/yq'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o ./yq.tar.gz "https://github.com/mikefarah/yq/releases/download/$version/yq_linux_amd64.tar.gz"
	tar xf ./yq.tar.gz

	chmod +x ./yq_linux_amd64
	mv ./yq_linux_amd64 ~/.local/bin/yq

	mkdir -p ~/.local/share/man/man1
	cp yq.1 ~/.local/share/man/man1
}

installed() {
	command -v yq &>/dev/null
}

util.if_file_sourced || _setup "$@"
