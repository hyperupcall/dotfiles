# shellcheck shell=bash

main() {
	if util.confirm 'Install Kitty?'; then
		install.kitty
	fi
}

install.kitty() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		yay -S kitty
		;;
	apt)
		sudo apt-get -y update
		sudo apt-get -y install kitty
		;;
	dnf)
		dnf check-update
		sudo dnf -y install kitty
		;;
	zypper)
		sudo zypper refresh
		sudo zypper -y install kitty
		;;
	esac
}
