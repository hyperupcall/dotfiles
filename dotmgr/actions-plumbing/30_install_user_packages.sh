# shellcheck shell=bash

# Name:
# Install user packages
#
# Description:
# Installs packages of various programming languages including
#
# Cargo
#   - starship
# Python
# GHC
# Basalt
#   - hyperupcall/*
#   - cykerway/complete-alias
#   - rcaloras/bash-preexec
#   - reconquest/shdoc
# Woof
# NPM
# Go
# Perl
# A lot of these are required since ~/.dots implicitly
# depends on things like starship, rsync, xclip, etc

main() {
	# -------------------------------------------------------- #
	#                           CARGO                          #
	# -------------------------------------------------------- #
	if util.confirm 'Install Rustup?'; then
		if ! util.is_cmd 'rustup'; then
			core.print_info "Installing rustup"
			util.req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
			rustup default nightly
		fi
	fi
	cargo install starship

	# -------------------------------------------------------- #
	#                          PYTHON                          #
	# -------------------------------------------------------- #
	if util.confirm 'Install Python?'; then
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
	fi

	# -------------------------------------------------------- #
	#                            GHC                           #
	# -------------------------------------------------------- #
	if util.confirm 'Install GHC?'; then
		core.print_info "Not implemented" # TODO (fully automate)
		# if ! command -v haskell >/dev/null 2>&1; then
		# 	core.print_info "Installing haskell"

		# 	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/ghcup"
		# 	ln -s "${XDG_DATA_HOME:-$HOME/.local/share}"/{,ghcup/.}ghcup

		# 	util.req https://get-ghcup.haskell.org | sh

		# 	util.req https://get.haskellstack.org/ | sh
		# fi
		:
	fi

	# -------------------------------------------------------- #
	#                          BASALT                          #
	# -------------------------------------------------------- #
	if util.confirm 'Install Basalt?'; then
		core.print_info 'Installing Basalt packages globally'
		basalt global add \
			hyperupcall/choose \
			hyperupcall/autoenv \
			hyperupcall/dotshellextract \
			hyperupcall/dotshellgen
		basalt global add \
			cykerway/complete-alias \
			rcaloras/bash-preexec \
			reconquest/shdoc
	fi

	# -------------------------------------------------------- #
	#                           WOOF                           #
	# -------------------------------------------------------- #
	if util.confirm 'Install Woof modules?'; then
		core.print_info 'Instaling Woof modules'
		woof install gh latest
		woof install nodejs latest
		woof install deno latest
		woof install go latest
		woof install nim latest
		woof install zig latest
	fi

	# -------------------------------------------------------- #
	#                            NPM                           #
	# -------------------------------------------------------- #
	if util.confirm 'Install NPM packages?'; then
		core.print_info 'Installing NPM Packages'
		npm i -g yarn pnpm
		yarn global add pnpm
		yarn global add diff-so-fancy
		yarn global add npm-check-updates
		yarn global add graphqurl
	fi

	# -------------------------------------------------------- #
	#                            GO                            #
	# -------------------------------------------------------- #
	if util.confirm 'Install Go?'; then
		go install golang.org/x/tools/gopls@latest
		go install golang.org/x/tools/cmd/godoc@latest

		go get github.com/motemen/gore/cmd/gore
		go get github.com/mdempsky/gocode
	fi

	# -------------------------------------------------------- #
	#                           PERL                           #
	# -------------------------------------------------------- #
	if util.confirm 'Install Perl things?'; then
		core.print_info "Not implemented" # TODO
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
	fi
}

