#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Caddy?'; then
		install.caddy
	fi
}

install.caddy() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	apt)
		sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
		local gpg_file="/etc/apt/keyrings/caddy-stable.asc"

		pkg.add_apt_key \
			'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
			"$gpg_file"
		pkg.add_apt_repository \
				"deb [signed-by=$gpg_file] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main
deb-src [signed-by=$gpg_file] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" \
				'/etc/apt/sources.list.d/caddy-stable.list'

		sudo apt update
		sudo apt install caddy
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

main "$@"
