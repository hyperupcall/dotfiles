# shellcheck shell=bash

main() {
	if util.confirm 'Install Kitty?'; then
		install.mongodb
	fi
}

install.mongodb() {
	util.get_package_manager
	declare pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo tee /etc/apt/trusted.gpg.d/mongodb-org-6.0.asc >/dev/null
		printf '%s\n' "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" \
			| sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

		sudo apt-get -y update
		sudo apt-get install -y mongodb-org
		;;
	apt)
		sudo apt-get -y update
		sudo apt-get -y install kitty
		;;
	dnf)
		:
		;;
	zypper)
		:
		;;
	esac
}

main "$@"
