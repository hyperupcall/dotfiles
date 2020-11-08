# shellcheck shell=bash
#
# ~/.bashrc
#

# shellcheck source=user/.profile
[ -r ~/.profile ] && source ~/.profile

[[ $- != *i* ]] && [ ! -t 0 ] && return

# shellcheck source=user/config/bash/bashrc.sh
source "${XDG_CONFIG_HOME:-"$HOME/.config"}/bash/bashrc.sh"
