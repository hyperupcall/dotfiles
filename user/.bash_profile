# shellcheck shell=bash
#
# ~/.bash_profile
#

source ~/.bashrc
export DVM_DIR="/home/edwin/.dvm"
export PATH="$DVM_DIR/bin:$PATH"

[[ -s "$HOME/data/rvm/scripts/rvm" ]] && source "$HOME/data/rvm/scripts/rvm" # Load RVM into a shell session *as a function*
