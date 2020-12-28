# shellcheck shell=bash
#
# ~/.bash_logout
#

[ "$SHLVL" = 1 ] && {
	clear
	# E3 extension (see clear(1))
	printf '\033[3J'
}
