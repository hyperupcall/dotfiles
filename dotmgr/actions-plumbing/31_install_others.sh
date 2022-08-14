# shellcheck shell=bash

# Name:
# Install miscellaneous
#
# Description:
# Installs miscellaneous packages. This includes:
# - 5. Dropbox
# - 6. Browserpass Brave Client (hard-coded to verison 3.0.9)
# - 7. XP-Pen Driver
# - 8. Git subcommands (git-recent, git-fresh, etc.)

main() {
	# 4. Bash
	if util.confirm 'Install Bash stuff?'; then
		# Frameworks
		util.clone_in_dots 'https://github.com/ohmybash/oh-my-bash'
		util.clone_in_dots 'https://github.com/bash-it/bash-it'
		source ~/.dots/.repos/bash-it/install.sh --no-modify-config

		# Prompts
		util.clone_in_dots 'https://github.com/magicmonty/bash-git-prompt'
		util.clone_in_dots 'https://github.com/riobard/bash-powerline'
		util.clone_in_dots 'https://github.com/barryclark/bashstrap'
		util.clone_in_dots 'https://github.com/lvv/git-prompt'
		util.clone_in_dots 'https://github.com/nojhan/liquidprompt'
		util.clone_in_dots 'https://github.com/arialdomartini/oh-my-git'
		util.clone_in_dots 'https://github.com/twolfson/sexy-bash-prompt'

		# Utilities
		util.clone_in_dots 'https://github.com/akinomyoga/ble.sh'
		util.clone_in_dots 'https://github.com/huyng/bashmarks'

		# Unused
		# util.clone 'https://github.com/basherpm/basher' ~/.dots/.repos/basher
	fi

	# 5. Dropbox
	if util.confirm 'Install Dropbox stuff?'; then
		cd ~/.dots/.home/Downloads
		wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
		ln -sf ~/.dots/.home/Downloads/.dropbox-dist/dropboxd ~/.dots/.usr/bin/dropboxd
	fi

	# 6. Browserpass
	if util.confirm 'Install Browserpass?'; then
		local version='3.7.2'
		core.print_info "Installing version '$version'"

		local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-linux64-$version.tar.gz"
		cd "$(mktemp -d)"


		curl -sSLo browserpass.tar.gz "$url"
		tar xf 'browserpass.tar.gz'
		cd "./browserpass-linux64-$version"

		local system='linux64'
		make BIN="browserpass-$system" PREFIX=/usr/local configure
		sudo make BIN="browserpass-$system" PREFIX=/usr/local install
		make BIN="browserpass-$system" PREFIX=/usr/local hosts-brave-user

		# Symlink things
		for f in \
			"$XDG_CONFIG_HOME/"{BraveSoftware/Brave-Browser,sidekick,wavebox}"/NativeMessagingHosts/com.github.browserpass.native.json"
		do
			mkdir -p "${f%/*}"
			ln -sf /usr/local/lib/browserpass/hosts/chromium/com.github.browserpass.native.json "$f"
		done; unset -v f

		for f in \
			"$XDG_CONFIG_HOME/"{BraveSoftware/Brave-Browser,sidekick,wavebox}"/policies/managed/com.github.browserpass.native.json"
		do
			mkdir -p "${f%/*}"
			ln -s "/usr/local/lib/browserpass/policies/chromium/com.github.browserpass.native.json" "$f"
		done; unset -v f
	fi

	# 7. XP-Pen Driver
	if util.confirm 'Install XP-Pen Driver?'; then
		core.print_info "Downloading and installing XP-Pen Driver"

		(
			cd "$(mktemp -d)"
			curl -fsSLo './xp-pen.tar.gz' 'https://www.xp-pen.com/download/file/id/1936/pid/421/ext/gz.html'
			tar xf './xp-pen.tar.gz'
			sudo ./xp-pen-pentablet-*/install.sh
		)

	fi

	# 8. Git
	if util.confirm 'Install Random Git packages?'; then
		util.clone_in_dots 'jayphelps/git-blame-someone-else'
		util.clone_in_dots 'davidosomething/git-ink'
		util.clone_in_dots 'qw3rtman/git-fire'
		util.clone_in_dots 'paulirish/git-recent'
		util.clone_in_dots 'imsky/git-fresh'
		util.clone_in_dots 'paulirish/git-open'
	fi
}
