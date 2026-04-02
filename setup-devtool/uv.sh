#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='uv'

install.any() {
	curl -LsSf https://astral.sh/uv/install.sh | sh
}

installed() {
	command -v uv &>/dev/null
}

util.if_file_sourced || _setup "$@"
