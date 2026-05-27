#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

install.any() {
	util.install_by_setup_distro_package --no-confirm 'Ghostty' 'ghostty' 'ghostty' "$@"
}

install.ubuntu() {
	/bin/bash -c "$(curl -K "$CURL_CONFIG" https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
}

util.if_file_sourced || _setup "$@"
