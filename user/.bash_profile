# shellcheck shell=bash
#
# ~/.bash_profile
#

# shellcheck source=user/.bashrc
. ~/.bashrc

export DVM_DIR="/home/edwin/.dvm"
export PATH="$DVM_DIR/bin:$PATH"
source "$HOME/.cargo/env"
source "/home/edwin/data/cargo/env"
