#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if [ -f ~/.bootstrap/done ]; then
		if util.confirm "You have already bootstraped your dotfiles. Do you wish to do it again?"; then :; else
			core.print_info 'Exiting'
			exit 0
		fi
	fi

	# Install generally useful dependencies.
	util.get_package_manager
	case $REPLY in
	pacman)
		sudo pacman -Syyu --noconfirm
		sudo pacman -S --noconfirm base-devel
		sudo pacman -S --noconfirm lvm2
		sudo pacman -S --noconfirm openssl # for starship
		;;
	apt)
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https
		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2
		sudo apt-get -y install libssl-dev # for starship
		;;
	dnf)
		sudo dnf -y update
		sudo dnf -y install dnf-plugins-core # For at least Brave
		sudo dnf -y install @development-tools
		sudo dnf -y install lvm2
		sudo dnf -y install openssl-devel # for starship
		;;
	zypper)
		sudo zypper -y update
		sudo zypper -y upgrade
		sudo zypper -y install -t pattern devel_basis
		sudo zypper -y install lvm
		sudo zypper -y install openssl-devel # for starship
		;;
	esac
	util.install_packages bash-completion curl rsync pass
	util.install_packages cmake ccache vim nano jq
	util.install_packages pkg-config # for starship

	# Ensure prerequisites.
	util.ensure mkdir -p "$XDG_CONFIG_HOME"

	# Remove distribution-specific dotfiles.
	util.ensure mkdir -p ~/.bootstrap/distro-dots
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			util.ensure mv "$file" ~/.bootstrap/distro-dots
		fi
	done

	~/scripts/setup/dotdrop.sh

	# Set current system profile.
	if [ -f ~/.dotfiles/.data/profile ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local cur=
		local options='desktop|laptop'
		while [[ $cur != @($options) ]]; do
			printf '%s' "System profile? ($options): "
			read -er cur
		done
		printf '%s\n' "$cur" > ~/.dotfiles/.data/profile
	fi

	# Fetch GithHub authorization tokens.
	if [ -f ~/.dotfiles/.data/github_token ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local hostname=$HOSTNAME

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -eri "Paste token: "

		local token="$REPLY"
		printf '%s\n' "$token" > ~/.dotfiles/.data/github_token
	fi

	> ~/.bootstrap/done :
	printf '%s\n' 'Done.'
}

main "$@"
