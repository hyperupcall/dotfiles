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

# shellcheck source=user/config/bash/bashrc.sh
source "$XDG_CONFIG_HOME/bash/bashrc.sh"

export GOPATH="$HOME/data/go-path"; export GOROOT="$HOME/.go"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g

[[ -s "/home/edwin/.gvm/scripts/gvm" ]] && source "/home/edwin/.gvm/scripts/gvm"
