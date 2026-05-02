#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Firefox Extensions'

install.any() {
	util.get_latest_github_release 'gorhill/uBlock'
	local latest_tag="$REPLY"
	install_extension "https://github.com/gorhill/uBlock/releases/download/$latest_tag/uBlock0_$latest_tag.firefox.signed.xpi"
	read -rp 'Press ENTER to continue...'

	util.get_latest_github_release 'ajayyy/SponsorBlock'
	local latest_tag="$REPLY"
	install_extension "https://github.com/ajayyy/SponsorBlock/releases/download/$latest_tag/FirefoxSignedInstaller.xpi"
	read -rp 'Press ENTER to continue...'

	util.get_latest_github_release 'violentmonkey/violentmonkey'
	local latest_tag="$REPLY"
	install_extension "https://github.com/violentmonkey/violentmonkey/releases/download/$latest_tag/violentmonkey-${latest_tag#v}.xpi"
	read -rp 'Press ENTER to continue...'
}

install.installed() {
	false
}

install_extension() {
	local url="$1"

	rm -f './extension.xpi'
	curl -K "$CURL_CONFIG" -o './extension.xpi' "$url"
	firefox -install -extension ./extension.xpi
}

util.if_file_sourced || _setup "$@"
