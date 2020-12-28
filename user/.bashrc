# shellcheck shell=bash
#
# ~/.bashrc
#

[ -r ~/.profile ] && source ~/.profile

[[ $- != *i* ]] && [ ! -t 0 ] && return

source "$XDG_CONFIG_HOME/bash/bashrc.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/data/rvm/bin"
