#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Jan'

install.debian() {
	util.get_latest_github_release 'janhq/jan'
	local latest_tag=$REPLY

	curl -K "$CURL_CONFIG" -o './jan.deb' \
		"https://github.com/janhq/jan/releases/download/$latest_tag/Jan_${latest_tag#v}_amd64.deb"
	sudo dpkg -i './jan.deb'
	rm -f './jan.deb'
}

install.ubuntu() {
	install.debian "$@"
}

install.installed() {
	command -v Jan-Desktop &>/dev/null
}

util.if_file_sourced || _setup "$@"
