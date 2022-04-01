# shellcheck shell=bash

# Name:
# Install packages
#
# Description:
# Installs operating system, cargo, and Basalt packages.
# A lot of these are required since ~/.dots implicitly
# depends on things like starship, rsync, xclip, etc

action() {
	if util.is_cmd 'pacman'; then
		print.info 'Updating, upgrading, and installing packages'
		sudo pacman -Syyu --noconfirm

		sudo pacman -S --noconfirm base-devel
		sudo pacman -S --noconfirm lvm2
		sudo pacman -Syu --noconfirm pkg-config openssl # for starship
		# sudo pacman -Syu --noconfirm browserpass-chrome

		sudo pacman -S --noconfirm rsync xclip
		if ! command -v yay &>/dev/null; then
			yay -S \
				visual-studio-code-bin visual-studio-code-insiders-bin \
				brave-browser brave-browser-beta
			# Required by 'github.com/cykerway/complete-alias'
			sudo pacman -S bash-completion
		fi
	elif util.is_cmd 'apt-get'; then
		print.info 'Updating, upgrading, and installing packages'
		sudo apt-get -y update
		sudo apt-get -y upgrade

		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2
		sudo apt-get -y install pkg-config libssl-dev # for starship
		# sudo apt-get -y install webext-browserpass

		sudo apt-get -y install rsync xclip
	elif util.is_cmd 'dnf'; then
		print.info 'Updating, upgrading, and installing packages'
		sudo dnf -y update
		sudo dnf -y upgrade

		sudo dnf -y install @development-tools
		sudo dnf -y install lvm2
		sudo dnf -y install pkg-config openssl-devel # for starship
		# sudo dnf -y install browserpass

		sudo dnf -y install rsync xclip
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
