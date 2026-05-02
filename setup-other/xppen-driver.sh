#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='XPPen Driver'

install.any() {
	core.print_info 'Downloading'
	curl -K "$CURL_CONFIG" -o './xp-pen.tar.gz' 'https://www.xp-pen.com/download/file/id/1936/pid/421/ext/gz.html'

	core.print_info 'Extracting'
	tar xf './xp-pen.tar.gz'

	core.print_info 'Installing'
	sudo ./XPPenLinux*/install.sh
}

install.installed() {
	[ -d /usr/lib/pentablet ]
}

util.if_file_sourced || _setup "$@"
