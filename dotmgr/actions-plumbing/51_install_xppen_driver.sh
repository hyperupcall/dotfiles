# shellcheck shell=bash

main() {
	if util.confirm 'Install XP-Pen Driver?'; then
		core.print_info "Downloading and installing XP-Pen Driver"

		(
			cd "$(mktemp -d)"
			curl -fsSLo './xp-pen.tar.gz' 'https://www.xp-pen.com/download/file/id/1936/pid/421/ext/gz.html'
			tar xf './xp-pen.tar.gz'
			sudo ./xp-pen-pentablet-*/install.sh
		)

	fi
}
