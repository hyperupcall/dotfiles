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

# shellcheck source=~/config/bash/bashrc.sh
source "$XDG_CONFIG_HOME/bash/bashrc.sh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/edwin/data/sdkman"
[[ -s "/home/edwin/data/sdkman/bin/sdkman-init.sh" ]] && source "/home/edwin/data/sdkman/bin/sdkman-init.sh"
