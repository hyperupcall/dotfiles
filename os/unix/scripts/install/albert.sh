#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Albert?'; then
		install.albert
	fi
}

install.albert() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	apt)
		local version='22.04'
		source /etc/os-release
		if [ "$ID" = 'zorin' ]; then
			if [ "$VERSION_ID" = 16 ]; then
				version='20.04'
			elif [ "$VERSION_ID" = 15 ]; then
				version='20.04'
			fi
		fi
		local gpg_file="/etc/apt/keyrings/albert"


		pkg.add_apt_key \
			"https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_$version/Release.key" \
			"$gpg_file"

		pkg.add_apt_repository \
			"deb [signed-by=$gpg_file] http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$version/ /" \
			'/etc/apt/sources.list.d/albert.list'

		sudo apt update
		sudo apt install albert
		;;
	esac
}

main "$@"
