# shellcheck shell=bash

main() {
	if util.confirm 'Install Perl packages?'; then
		# https://github.com/regnarg/urxvt-config-reload
		cpan -i App::cpanminus

		# cpan Loading internal logger. Log::Log4perl recommended for better logging
		cpanm Log::Log4perl

		pkgs='AnyEvent Linux::FD common::sense'
		cpanm $pkgs
	fi
}

main "$@"
