# shellcheck shell=bash
#
# ~/.bash_logout
#

[ "$SHLVL" = 1 ] && {
	# E3 extension (see clear(1))
	clear || printf '\033[3J'
}
