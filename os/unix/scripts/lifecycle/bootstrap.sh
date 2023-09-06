#!/usr/bin/env bash

# Name:
# Bootstrap
#
# Description:
# Bootstraps dotfiles
#
# It
# - Installs dev build tools
# - Installs jq
# - Installs curl
# - Moves distro dotfiles (to ~/.bootstrap/distro-dots)
# - Downloads GitHub authorization tokens

source "${0%/*}/../source.sh"

main() {
	if [ -f ~/.bootstrap/done ]; then
		if util.confirm "It seems you have already bootstraped your dotfiles, do you wish to do it again?"; then :; else
			util.die 'Exiting'
		fi
	fi

	# Ensure prerequisites
	util.ensure mkdir -p ~/.bootstrap/distro-dots "$XDG_CONFIG_HOME"

	if util.is_cmd 'jq'; then
		core.print_info 'Already installed jq'
	else
		core.print_info 'Installing jq'
		util.install_pkg 'jq'
	fi

	if util.is_cmd 'curl'; then
		core.print_info 'Already installed curl'
	else
		core.print_info 'Installing curl'
		util.install_pkg 'curl'
	fi

	# Remove distribution specific dotfiles, including
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			util.ensure mv "$file" ~/.bootstrap/distro-dots
		fi
	done

	# Get GithHub authorization tokens
	if [ -f ~/.dotfiles/.data/github_token ]; then
		core.print_info 'Already stored GitHub token'
	else
		local hostname=
		hostname=$(hostname)

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -eri "Paste token: "

		local token="$REPLY"
		printf '%s\n' "$token" > ~/.dotfiles/.data/github_token
	fi

	> ~/.bootstrap/done :
	printf '%s\n' 'Done.'
}

main "$@"
