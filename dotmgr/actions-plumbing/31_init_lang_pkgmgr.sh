# shellcheck shell=bash

# Name:
# Init lang pkgmgr
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

