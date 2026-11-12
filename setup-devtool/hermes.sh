#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Hermes Agent'

install.any() {
	curl -K "$CURL_CONFIG" https://hermes-agent.nousresearch.com/install.sh | \
		GIT_CONFIG_COUNT=1 \
		GIT_CONFIG_KEY_0='clone.defaultRemoteName' \
		GIT_CONFIG_VALUE_0='origin' \
		bash -s -- --non-interactive
}

install.installed() {
	command -v hermes &>/dev/null
}

util.if_file_sourced || _setup "$@"
