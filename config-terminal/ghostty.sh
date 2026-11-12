#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Ghostty'

install.any() {
	util.install_by_setup_distro_package 'Ghostty' 'ghostty' 'ghostty' --no-confirm "$@"
}

install.ubuntu() {
	/bin/bash -c "$(curl -K "$CURL_CONFIG" 'https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh')"
}

install.installed() {
	command -v ghostty &>/dev/null
}

util.if_file_sourced || _setup "$@"
