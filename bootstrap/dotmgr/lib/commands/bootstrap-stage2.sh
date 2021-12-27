# shellcheck shell=bash

subcmd() {
	while :; do
		printf '%s' "What would you like to do?
(0): Quit
(1): Deploy dotfox dotfiles
       This simply executes dotfox with the right arguments. The command is shown
       before it is ran
(2): Install packages
       Installs operating system, cargo, and Basalt packages. A lot of these are required
       since ~/.dots implicitly depends on things like starship, rsync, xclip, etc.
> "
		if ! IFS= read -rN1; then
			die "Failed to get input"
		fi
		printf '\n'

		case "$REPLY" in
			$'\x04'|0|q) exit 0 ;;
			1) do_dotfox ;;
			2) do_install_packages ;;
			*) printf '%s\n' "Invalid option. Try again"
		esac
	done
}

do_dotfox() {
	prompt_run() {
		util.log_info "Would you like to run the following?"
		printf '%s\n%s' "$ $*" "(y/n): "
		if ! read -rN1; then
			util.die "Failed to get input"
		fi
		printf '\n'

		if [ "$REPLY" = y ]; then
			if "$@"; then :; else
				return $?
			fi
		else
			util.log_info "Skipping command"
		fi
	}

	prompt_run dotfox --config-dir="$HOME/.dots/user/.config/dotfox" --deployment=all.sh deploy
}

do_install_packages() {
	if util.is_cmd pacman; then
		util.log_info 'Updating, upgrading, and installing packages'
		sudo pacman -Syyu --noconfirm

		sudo pacman -Syu --noconfirm base-devel
		sudo pacman -Syu --noconfirm lvm2
		# sudo pacman -Syu --noconfirm pkg-config openssl
		# sudo pacman -Syu --noconfirm browserpass-chrome

		sudo pacman -Syu --noconfirm rsync xclip
	elif util.is_cmd apt-get; then
		util.log_info 'Updating, upgrading, and installing packages'
		sudo apt-get -y update
		sudo apt-get -y upgrade

		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2
		sudo apt-get -y install pkg-config libssl-dev # for starship
		sudo apt-get -y install webext-browserpass

		sudo apt-get -y install rsync xclip
	elif util.is_cmd dnf; then
		util.log_info 'Updating, upgrading, and installing packages'
		sudo dnf -y update
		sudo dnf -y upgrade

		sudo dnf -y install lvm2
		sudo dnf -y install pkg-config openssl-devel # for starship
		# sudo dnf -y install browserpass

		sudo dnf -y install rsync xclip
	fi

	dotmgr module rust
	if ! util.is_cmd starship; then
		util.log_info 'Installing starship'
		cargo install starship
	fi

	util.log_info 'Installing Basalt packages globally'
	basalt global add hyperupcall/choose hyperupcall/autoenv hyperupcall/dotshellextract hyperupcall/dotshellgen
	basalt global add cykerway/complete-alias rcaloras/bash-preexec
	basalt global add hedning/nix-bash-completions dsifford/yarn-completion
}
