# shellcheck shell=bash

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
# - Moves distro dotfiles (to ~/.bootstrap)
# - Installs Nim (in ~/.bootstrap)
# - Installs dotfox (in ~/.bootstrap)

{
	if [ -d ~/.bootstrap/done ]; then
		if util.confirm "It seems you have already bootstraped your dotfiles, do you wish to do it again?"; then :; else
			util.die 'Exiting'
		fi
	fi

	# Ensure prerequisites
	util.ensure mkdir -p ~/.bootstrap/{bin,distro-dots} "$XDG_CONFIG_HOME"

	# Nim requires GCC for compilation (done below)
	if util.is_cmd 'gcc'; then
		core.print_info 'Already installed gcc'
	else
		core.print_info 'Installing gcc'
		util.install_pkg 'gcc'
	fi

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

	# Download Nim (in case dotfox doesn't work, it may need to be recompiled)
	if [ ! -d ~/.bootstrap/nim ]; then
		core.print_info 'Downloading Nim'
		util.ensure cd ~/.bootstrap
			declare nim_version='1.6.8'
			util.ensure curl -LSso "./nim-$nim_version-linux_x64.tar.xz" "https://nim-lang.org/download/nim-$nim_version-linux_x64.tar.xz"
			util.ensure rm -rf "./nim-$nim_version"
			util.ensure tar xf "./nim-$nim_version-linux_x64.tar.xz"
			util.ensure rm -rf "./nim-$nim_version-linux_x64.tar.xz"
			util.ensure ln -sTf "$HOME/.bootstrap/nim-$nim_version" './nim'
			unset -v nim_version
		util.ensure cd
	fi

	# Clone dotfox
	if [ ! -d ~/.bootstrap/dotfox ]; then
		core.print_info 'Cloning github.com/hyperupcall/dotfox'
		util.ensure git clone --quiet https://github.com/hyperupcall/dotfox ~/.bootstrap/dotfox
		util.ensure cd ~/.bootstrap/dotfox
			"$HOME/.bootstrap/nim/bin/nimble" -y --nim="$HOME/.bootstrap/nim/bin/nim" build
		util.ensure cd
	fi

	# Download dotfox
	if [ ! -f ~/.bootstrap/bin/dotfox ]; then
		core.print_info 'Downloading Dotfox'
		if ! dotfox_download_url="$(
			curl -LfSs https://api.github.com/repos/hyperupcall/dotfox/releases/latest \
				| jq -r '.assets[0].browser_download_url'
		)"; then
			core.print_die "Could not fetch the dotfox download URL"
		fi
		util.ensure curl -LsSo ~/.bootstrap/bin/dotfox "$dotfox_download_url"
		util.ensure chmod +x ~/.bootstrap/bin/dotfox
	fi

	# Get GithHub authorization tokens
	if [ ! -f ~/.dotfiles/.data/github_token ]; then
		declare hostname=
		hostname=$(hostname)

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -eri "Paste token: "

		declare token="$REPLY"
		printf '%s\n' "$token" > ~/.dotfiles/.data/github_token
	fi

	> ~/.bootstrap/done :
}
