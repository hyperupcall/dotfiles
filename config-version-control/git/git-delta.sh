#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='delta'

install.any() {
	cargo install --force git-delta
}

installed() {
	command -v delta &>/dev/null
	local delta_version=
	delta_version=$(delta --version)
	[[ "$delta_version" == 'delta '* ]]
}

util.if_file_sourced || _setup "$@"
