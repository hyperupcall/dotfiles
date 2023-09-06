#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install PowershellCore?'; then
		install.powershell_core
	fi
}

install.powershell_core() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		echo 'not implemented'
		;;
	apt)
		curl -fsSLo- https://packages.microsoft.com/keys/microsoft.asc | sudo tee >/dev/null /etc/apt/trusted.gpg.d/microsoft.asc
		sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'
		sudo apt-get -y update
		sudo apt-get -y install powershell
		;;
	dnf)
		echo 'not implemented'
		;;
	zypper)
		echo 'not implemented'
		;;
	esac
}

main "$@"
