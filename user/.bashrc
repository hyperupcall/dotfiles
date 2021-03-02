# shellcheck shell=bash
#
# ~/.bashrc
#

[ -r ~/.profile ] && source ~/.profile

[[ $- != *i* ]] && [ ! -t 0 ] && return

source "$XDG_CONFIG_HOME/bash/bashrc.sh"

