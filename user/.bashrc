# shellcheck shell=bash
#
# ~/.bashrc
#

[ -r ~/.profile ] && source ~/.profile

[[ $- != *i* ]] && [ ! -t 0 ] && return

source "$XDG_CONFIG_HOME/bash/bashrc.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/data/rvm/bin"
source "/home/edwin/data/cargo/env"

PATH="/home/edwin/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/edwin/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/edwin/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/edwin/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/edwin/perl5"; export PERL_MM_OPT;
