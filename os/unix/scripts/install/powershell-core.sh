#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Powershell Core?'; then
		install.powershell_core
	fi
}

install.powershell_core() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		printf '%s\n' 'Not implemented'
		;;
	apt)
		curl -fsSLo- https://packages.microsoft.com/keys/microsoft.asc | sudo tee >/dev/null /etc/apt/trusted.gpg.d/microsoft.asc
		sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'
		sudo apt-get -y update
		sudo apt-get -y install powershell
		;;
	dnf)
		printf '%s\n' 'Not implemented'
		;;
	zypper)
		printf '%s\n' 'Not implemented'
		;;
	esac
}

main "$@"
