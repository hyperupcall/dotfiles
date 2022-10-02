# shellcheck shell=bash

# Name: Init system pkgmgr
#
# Description:
# Initialize system package manager
# Uses either pacman, apt, dnf, or zypper to install any of the following packages:
#  - VSCode
#  - Brave
# Updates are handled automatically

main() {
	# -------------------------------------------------------- #
	#                          SYSTEM                          #
	# -------------------------------------------------------- #
	local package_manager= did_package_manager='no'
	for package_manager in pacman apt dnf zypper; do
		if util.is_cmd "$package_manager"; then
			did_package_manager='yes'

			install.upgrade_os "$package_manager"
			install.core_packages "$package_manager"
		fi
	done; unset -v package_manager

	if [ "$did_package_manager" = 'no' ]; then
		core.print_warn "No supported system package manager detected"
	fi
}

install.upgrade_os() {
	local pkgmngr="$1"

	core.print_info 'Updating and upgrading operating system'

	case $pkgmngr in
	pacman)
		sudo pacman -Syyu --noconfirm
		;;
	apt)
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https
		;;
	dnf)
		sudo dnf -y update
		sudo dnf install dnf-plugins-core # For at least Brave
		;;
	zypper)
		sudo zypper -y update
		sudo zypper -y upgrade
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}


install.core_packages() {
	local pkgmngr="$1"

	core.print_info 'Updating and upgrading operating system'

	case $pkgmngr in
	pacman)
		sudo pacman -S --noconfirm base-devel
		sudo pacman -S --noconfirm lvm2 bash-completion curl rsync pass
		sudo pacman -Syu --noconfirm pkg-config openssl # for starship
		;;
	apt)
		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2 bash-completion curl rsync pass
		sudo apt-get -y install pkg-config libssl-dev # for starship
		;;
	dnf)
		sudo dnf -y install @development-tools
		sudo dnf -y install lvm2 bash-completion curl rsync pass
		sudo dnf -y install pkg-config openssl-devel # for starship
		;;
	zypper)
		sudo zypper -y install -t pattern devel_basis
		sudo zypper -y install lvm bash-completion curl rsync pass
		sudo zypper -y install pkg-config openssl-devel # for starship
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}
