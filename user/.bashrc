# shellcheck shell=bash
#
# ~/.bashrc
#

[ -r ~/.profile ] && source ~/.profile

[[ $- != *i* ]] && return

source "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc.sh"
