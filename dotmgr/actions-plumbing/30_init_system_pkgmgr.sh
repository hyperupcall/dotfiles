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

			if util.confirm 'Install VSCode and VSCode Insiders?'; then
				install.vscode "$package_manager"
			fi

			if util.confirm 'Install Brave and Brave Beta?'; then
				install.brave "$package_manager"
			fi
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

install.vscode() {
	local pkgmngr="$1"

	core.print_info 'Installing VSCode and VSCode Insiders'

	case $pkgmngr in
	pacman)
		yay -S visual-studio-code-bin visual-studio-code-insiders-bin
		;;
	apt)
		curl -fsSLo- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > './packages.microsoft.gpg'
		sudo install -o root -g root -m 644 './packages.microsoft.gpg' '/etc/apt/trusted.gpg.d'
		rm -f './packages.microsoft.gpg'
		printf '%s\n' "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
			| sudo tee '/etc/apt/sources.list.d/vscode.list'

		sudo apt-get -y update
		sudo apt-get -y install code code-insiders
		;;
	dnf)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
			| sudo tee '/etc/yum.repos.d/vscode.repo'

		sudo dnf check-update
		sudo dnf -y install code code-insiders
		;;
	zypper)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
				| sudo tee '/etc/zypp/repos.d/vscode.repo'

		sudo zypper refresh
		sudo zypper -y install code code-insiders
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

install.brave() {
	local pkgmngr="$1"

	core.print_info 'Installing Brave and Brave Beta'

	case $pkgmngr in
	pacman)
		yay -S brave-browser brave-browser-beta
		;;
	apt)
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-release.list'
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-beta-archive-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-beta.list'

		sudo apt-get -y update
		sudo apt-get -y install brave-browser brave-browser-beta
		;;
	dnf)
		sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
		sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
		sudo dnf config-manager --add-repo https://brave-browser-rpm-beta.s3.brave.com/x86_64/
		sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc

		dnf check-update
		sudo dnf -y install brave-browser brave-browser-beta
		;;
	zypper)
		sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
		sudo zypper -y addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
		sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc
		sudo zypper addrepo https://brave-browser-rpm-beta.s3.brave.com/x86_64/ brave-browser-beta

		sudo zypper refresh
		sudo zypper -y install brave-browser brave-browser-beta
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

