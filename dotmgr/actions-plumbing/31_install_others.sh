# shellcheck shell=bash

# Name:
# Install Others
#
# Description:
# Installs miscellaneous packages. This includes:
# - 3. GHC (SKIPPED)
# - 4. Bash
# - 5. Dropbox
# - 6. Browserpass Brave Client (hard-coded to verison 3.0.9)
# - 7. XP-Pen Driver
# - 8. Git subcommands (git-recent, git-fresh, etc.)

main() {
	# 4. Bash
	{
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
	}

	# 5. Dropbox
	{
		cd ~/.dots/.home/Downloads
		wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
		ln -sf ~/.dots/.home/Downloads/.dropbox-dist/dropboxd ~/.dots/.usr/bin/dropboxd
	}

	# 6. Browserpass
	{
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
	}

	# 7. XP-Pen Driver
	{
		core.print_info "Downloading and installing XP-Pen Driver"

		cd "$(mktemp -d)"
		local download_file=
		download_file="https://www.xp-pen.com$(curl -fsSL "https://www.xp-pen.com/download-421.html" | grep -A 10 '.tar.gz' | grep '/download' | sed -Ene 's|.*"(.*?)".*|\1|p')"
		curl -fsSLo "xp-pan.tar.gz" "$download_file"
		sudo ./*/install.sh
	}

	# 8. Git
	{
		util.clone_in_dots 'jayphelps/git-blame-someone-else'
		util.clone_in_dots 'davidosomething/git-ink'
		util.clone_in_dots 'qw3rtman/git-fire'
		util.clone_in_dots 'paulirish/git-recent'
		util.clone_in_dots 'imsky/git-fresh'
		util.clone_in_dots 'paulirish/git-open'
	}
	# TODO
# Perl
# git clone https://github.com/tokuhirom/plenv ~/.dots/.repos/plenv
# git clone git://github.com/tokuhirom/Perl-Build.git "$(plenv root)/plugins/perl-build"

# # https://github.com/regnarg/urxvt-config-reload
# pkg="AnyEvent Linux::FD common::sense"
# if command -v cpan >/dev/null >&2; then
# 	cpan -i App::cpanminus
# fi

# if command -v cpanm >/dev/null >&2; then
# 	# cpan Loading internal logger. Log::Log4perl recommended for better logging
# 	cpanm Log::Log4perl

# 	cpanm $pkg
# fi
}
