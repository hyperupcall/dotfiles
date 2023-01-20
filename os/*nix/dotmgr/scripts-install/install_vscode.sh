# shellcheck shell=bash

{
	if util.confirm 'Install VSCode and VSCode Insiders?'; then
		install.vscode
	fi
}

install.vscode() {
	util.get_package_manager
	declare pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		yay -S visual-studio-code-bin visual-studio-code-insiders-bin
		;;
	apt)
		curl -fsSLo- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > './packages.microsoft.gpg'
		sudo install -o root -g root -m 644 './packages.microsoft.gpg' '/etc/apt/trusted.gpg.d'
		rm -f './packages.microsoft.gpg'
		printf '%s\n' "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
			| sudo tee '/etc/apt/sources.list.d/vscode.list' >/dev/null

		sudo apt-get -y update
		sudo apt-get -y install code code-insiders
		;;
	dnf)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
			| sudo tee '/etc/yum.repos.d/vscode.repo' >/dev/null

		sudo dnf check-update
		sudo dnf -y install code code-insiders
		;;
	zypper)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
				| sudo tee '/etc/zypp/repos.d/vscode.repo' >/dev/null

		sudo zypper refresh
		sudo zypper -y install code code-insiders
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}
