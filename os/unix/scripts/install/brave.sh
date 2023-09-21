#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Brave?'; then
		install.brave
	fi
}

install.brave() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	util.get_os_id
	local os_id="$REPLY"

	case $pkgmngr in
	pacman)
		if [ "$os_id" = 'manjaro' ]; then
			yay -S brave-browser brave-browser-beta
		else
			yay -S brave brave-bin brave-beta-bin
		fi
		;;
	apt)
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-release.list' >/dev/null
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-beta-archive-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-beta.list' >/dev/null

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

main "$@"
