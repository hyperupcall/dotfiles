# shellcheck shell=bash

util.ensure_bin perl

# todo: remove prompt (on unconfigured systems)
# todo: cleanup
print.info "Installing perl"

git clone https://github.com/tokuhirom/plenv "${XDG_DATA_HOME:-${HOME}/.local/share}/plenv"
git clone git://github.com/tokuhirom/Perl-Build.git "$(plenv root)/plugins/perl-build"

# https://github.com/regnarg/urxvt-config-reload
pkg="AnyEvent Linux::FD common::sense"
if command -v cpan >/dev/null >&2; then
	cpan -i App::cpanminus
fi

if command -v cpanm >/dev/null >&2; then
	# cpan Loading internal logger. Log::Log4perl recommended for better logging
	cpanm Log::Log4perl

	cpanm $pkg
fi

unset -v pkg
