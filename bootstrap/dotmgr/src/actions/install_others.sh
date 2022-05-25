# shellcheck shell=bash

# Name:
# Install Others
#
# Description:
# Installs miscellaneous packages. This includes:
# - 1. Rust (through rustup)
# - 2. Python
# - 3. GHC (SKIPPED)
# - 4. Bash
# - 5. Dropbox
# - 6. Browserpass Brave Client (hard-coded to verison 3.0.9)
# - 7. Git subcommands (git-recent, git-fresh, etc.)

action() {
	# 1. Rust
	{
		if ! util.is_cmd 'rustup'; then
			core.print_info "Installing rustup"
			util.req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
			rustup default nightly
		fi
	}

	# 2. Python
	{
		if ! util.is_cmd 'pip'; then
			core.print_info "Installing pip"
			python3 -m ensurepip --upgrade
		fi
		python3 -m pip install --upgrade pip

		pip3 install wheel


		if ! util.is_cmd 'pipx'; then
			core.print_info "Installing pipx"
			python3 -m pip install --user pipx
			python3 -m pipx ensurepath
		fi

		if ! util.is_cmd 'poetry'; then
			core.print_info "Installing poetry"
			util.req https://install.python-poetry.org | python3 -
		fi
	}

	# 3. GHC
	{
		# TODO: fully automate
		# if ! command -v haskell >/dev/null 2>&1; then
		# 	core.print_info "Installing haskell"

		# 	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/ghcup"
		# 	ln -s "${XDG_DATA_HOME:-$HOME/.local/share}"/{,ghcup/.}ghcup

		# 	util.req https://get-ghcup.haskell.org | sh

		# 	util.req https://get.haskellstack.org/ | sh
		# fi
		:
	}

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
		local version='3.0.10'
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
	}

	# 7. Git
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

# ZSH


# Frameworks
# antibody
# util.req 'https://git.io/antibody' | sh -s -- -b ~/.dots/.usr/bin/

# # antigen
# util.req 'https://git.io/antigen' > ~/.dots/.usr/share/antigen.zsh

# # oh-my-zsh
# util.clone_in_dots 'https://github.com/ohmyzsh/oh-my-zsh'

# # prezto
# util.clone_in_dots 'https://github.com/sorin-ionescu/prezto'

# # sheldon
# uril.req 'https://rossmacarthur.github.io/install/crate.sh' | bash -s -- --repo 'rossmacarthur/sheldon' --to ~/.dots/.usr/bin

# # zgen
# util.clone_in_dots 'https://github.com/tarjoilija/zgen'

# # zimfw
# util.req 'https://raw.githubusercontent.com/zimfw/install/master/install.zsh' | zsh

# # zinit
# util.req 'https://git.io/zinit-install' | zsh

# # zplug
# util.req 'https://raw.githubusercontent.com/zplug/installer/master/installer.zsh' | zsh


#
}
