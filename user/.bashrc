# shellcheck shell=bash
#
# ~/.bashrc
#

# shellcheck source=user/.profile
[ -r ~/.profile ] && source ~/.profile

[[ $- != *i* ]] && [ ! -t 0 ] && return

[ -z  "$XDG_CONFIG_HOME" ] && {
	echo '$XDG_CONFIG_HOME must be set. Exiting'
	exit 1
}

# shellcheck source=/dev/null
source "$XDG_CONFIG_HOME/bash/bashrc.sh"
