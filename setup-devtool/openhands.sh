#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='OpenHands'

install.any() {
	uv tool install openhands --python 3.12
}

install.installed() {
	command -v openhands &>/dev/null
}

util.if_file_sourced || _setup "$@"
