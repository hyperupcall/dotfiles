# shellcheck shell=bash

# Name:
# Install core packages
#
# Description:
# For base: base-devel, build-essential, @development-tools, etc.
# For core: lvm2, bash-completion, curl, rsync, pass
# For starship: pkg-config openssl
# For C++: cmake, ccache
# For backup editing: vim, nano

main() {
	util.get_package_manager
	declare pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		sudo pacman -Syyu --noconfirm
		sudo pacman -S --noconfirm base-devel
		sudo pacman -S --noconfirm lvm2 bash-completion curl rsync pass
		sudo pacman -S --noconfirm pkg-config openssl # for starship
		sudo pacman -S --noconfirm cmake ccache vim nano
		;;
	apt)
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https
		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2 bash-completion curl rsync pass
		sudo apt-get -y install pkg-config libssl-dev # for starship
		sudo apt-get -y install cmake ccache vim nano
		;;
	dnf)
		sudo dnf -y update
		sudo dnf install dnf-plugins-core # For at least Brave
		sudo dnf -y install @development-tools
		sudo dnf -y install lvm2 bash-completion curl rsync pass
		sudo dnf -y install pkg-config openssl-devel # for starship
		sudo dnf -y install cmake ccache vim nano
		;;
	zypper)
		sudo zypper -y update
		sudo zypper -y upgrade
		sudo zypper -y install -t pattern devel_basis
		sudo zypper -y install lvm bash-completion curl rsync pass
		sudo zypper -y install pkg-config openssl-devel # for starship
		sudo zypper -y install cmake ccache vim nano
		;;
	esac
}

main "$@"
