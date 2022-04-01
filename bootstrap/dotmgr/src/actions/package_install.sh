# shellcheck shell=bash

# Name:
# Install packages
#
# Description:
# Installs operating system, cargo, and Basalt packages.
# A lot of these are required since ~/.dots implicitly
# depends on things like starship, rsync, xclip, etc

action() {
	# -------------------------------------------------------- #
	#                          PACMAN                          #
	# -------------------------------------------------------- #
	if util.is_cmd 'pacman'; then
		print.info 'Updating, upgrading, and installing packages'
		sudo pacman -Syyu --noconfirm

		{
			# Generic
			sudo pacman -S --noconfirm base-devel
			sudo pacman -S --noconfirm lvm2 bash-completion curl rsync
			sudo pacman -Syu --noconfirm pkg-config openssl # for starship
			# sudo pacman -Syu --noconfirm browserpass-chrome
		}
		{
			# VSCode
			yay -S visual-studio-code-bin visual-studio-code-insiders-bin

			# Brave, Brave Beta
			yay -S brave-browser brave-browser-beta
		}


	# -------------------------------------------------------- #
	#                            APT                           #
	# -------------------------------------------------------- #
	elif util.is_cmd 'apt-get'; then
		print.info 'Updating, upgrading, and installing packages'
		sudo apt-get -y update && sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https

		{
			# Generic
			sudo apt-get -y install build-essential
			sudo apt-get -y install lvm2 bash-completion curl rsync
			sudo apt-get -y install pkg-config libssl-dev # for starship
			# sudo apt-get -y install webext-browserpass
		}
		{
			# VSCode
			wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
			sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
			printf '%s\n' "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
				| sudo tee /etc/apt/sources.list.d/vscode.list
			rm -f packages.microsoft.gpg

			# Brave
			sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
			printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
				| sudo tee /etc/apt/sources.list.d/brave-browser-release.list

			# Brave Beta
			sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
			printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-beta-archive-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" \
				| sudo tee /etc/apt/sources.list.d/brave-browser-beta.list

			sudo apt-get -y update
			sudo apt-get -y install code code-insiders
			sudo apt-get -y install brave-browser brave-browser-beta
		}


	# -------------------------------------------------------- #
	#                            DNF                           #
	# -------------------------------------------------------- #
	elif util.is_cmd 'dnf'; then
		print.info 'Updating, upgrading, and installing packages'
		sudo dnf -y update
		sudo dnf install dnf-plugins-core # For at least Brave

		{
			# Generic
			sudo dnf -y install @development-tools
			sudo dnf -y install lvm2 bash-completion curl rsync
			sudo dnf -y install pkg-config openssl-devel # for starship
			# sudo dnf -y install browserpass
		}
		{
			# VSCode
			sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
				| sudo tee /etc/yum.repos.d/vscode.repo

			# Brave
			sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
			sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

			# Brave Beta
			sudo dnf config-manager --add-repo https://brave-browser-rpm-beta.s3.brave.com/x86_64/
			sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc

			dnf check-update
			sudo dnf -y install code code-insiders
			sudo dnf -y install brave-browser brave-browser-beta
		}


		# -------------------------------------------------------- #
		#                          ZYPPER                          #
		# -------------------------------------------------------- #
	elif util.is_cmd 'zypper'; then
		print.info 'Updating, upgrading, and installing packages'
		sudo zypper -y update && sudo zypper -y upgrade

		{
			# General
			sudo zypper -y install -t pattern devel_basis
			sudo zypper -y install lvm bash-completion curl rsync
			sudo zypper -y install pkg-config openssl-devel # for starship
			# sudo zypper -y install browserpass
		}
		{
			# VSCode
			sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
				| sudo tee /etc/zypp/repos.d/vscode.repo

			# Brave
			sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
			sudo zypper -y addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser

			# Brave Beta
			sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc
			sudo zypper addrepo https://brave-browser-rpm-beta.s3.brave.com/x86_64/ brave-browser-beta

			# Install
			sudo zypper refresh
			sudo zypper -y install code code-insiders
			sudo zypper -y install brave-browser brave-browser-beta
		}
	fi

	dotmgr module rust
	if ! util.is_cmd 'starship'; then
		print.info 'Installing starship'
		cargo install starship
	fi

	print.info 'Installing Basalt packages globally'
	basalt global add hyperupcall/choose hyperupcall/autoenv hyperupcall/dotshellextract hyperupcall/dotshellgen
	basalt global add cykerway/complete-alias rcaloras/bash-preexec
}
