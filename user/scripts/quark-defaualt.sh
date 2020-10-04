#!/usr/bin/env sh

set -eu

case "$@" in
	--help|-h)
		cat 0<<-HELPTEXT
			quark-default

			Commands:
			  set [application] [value]

			Options:
			  --help      Show the help menu
			  --version   Show the current version

		HELPTEXT
		;;
	esac

# browser
surf, vimprobable, vimprobabl2, qutebrowser, dwb, jumanji, luakit, ubzl, midori, chromium, google-chrome, opera, firefox, seamonkey, iceweasel, epiphany, konqueror, elinks, links2, links, lynx, w3m
