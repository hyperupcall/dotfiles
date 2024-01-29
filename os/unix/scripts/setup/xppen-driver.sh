#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install XP-Pen Driver?'; then (
		cd "$(mktemp -d)" &>/dev/null
		core.print_info 'Downloading'
		curl -fsSLo './xp-pen.tar.gz' 'https://www.xp-pen.com/download/file/id/1936/pid/421/ext/gz.html'

		core.print_info 'Extracting'
		tar xf './xp-pen.tar.gz'

		core.print_info 'Installing'
		bash
#		sudo XPPenLinux*/install.sh
	) fi
}

main "$@"
