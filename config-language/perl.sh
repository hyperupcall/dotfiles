#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Perl'

install.any() {
	# https://github.com/regnarg/urxvt-config-reload
	cpan -i App::cpanminus

	# cpan Loading internal logger. Log::Log4perl recommended for better logging
	cpanm Log::Log4perl

	pkgs=(AnyEvent Linux::FD common::sense)
	cpanm "${pkgs[@]}"
}

installed() {
	# TODO
	false
}

util.if_file_sourced || _setup "$@"
