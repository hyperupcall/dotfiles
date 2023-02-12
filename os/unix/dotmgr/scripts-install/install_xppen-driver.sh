# shellcheck shell=bash

main() {
	if util.confirm 'Install XP-Pen Driver?'; then
		util.cd_temp

		core.print_info 'Downloading'
		curl -fsSLo './xp-pen.tar.gz' 'https://www.xp-pen.com/download/file/id/1936/pid/421/ext/gz.html' || util.die

		core.print_info 'Extracting'
		tar xf './xp-pen.tar.gz' || util.die

		core.print_info 'Installing'
		sudo ./xp-pen-pentablet-*/install.sh || util.die

		popd >/dev/null
	fi
}

main "$@"
