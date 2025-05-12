#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Firefox Extensions'

main() {
	helper.setup "$@"
}

install.any() {
	util.get_latest_github_tag 'gorhill/uBlock'
	local latest_tag="$REPLY"
	util.install "https://github.com/gorhill/uBlock/releases/download/$latest_tag/uBlock0_$latest_tag.firefox.signed.xpi"
	read -rp 'Press ENTER to continue...'

	util.get_latest_github_tag 'ajayyy/SponsorBlock'
	local latest_tag="$REPLY"
	util.install "https://github.com/ajayyy/SponsorBlock/releases/download/$latest_tag/FirefoxSignedInstaller.xpi"
	read -rp 'Press ENTER to continue...'

	util.get_latest_github_tag 'violentmonkey/violentmonkey'
	local latest_tag="$REPLY"
	util.install "https://github.com/violentmonkey/violentmonkey/releases/download/$latest_tag/violentmonkey-${latest_tag#v}.xpi"
	read -rp 'Press ENTER to continue...'
}

util.install() {
	local url="$1"

	rm -f './extension.xpi'
	curl -K "$CURL_CONFIG" -o './extension.xpi' "$url"
	firefox -install -extension ./extension.xpi
}

util.if_file_sourced || helper.run_main "$@"
