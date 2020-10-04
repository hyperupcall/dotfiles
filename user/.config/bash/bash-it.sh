#!/bin/bash

export BASH_IT="$HOME/.config/bash/bash-it"
export BASH_IT_THEME="powerline-multiline"
export GIT_HOSTING='git@github.com'
# don't check mail when opening terminal.
unset MAILCHECK
export IRC_CLIENT='irssi'
# enable VCS checking for use in the prompt
export SCM_CHECK=false
#source "$BASH_IT"/bash_it.sh

# shellcheck source=user/.config/bash/bash-it/bash_it.sh
source "$BASH_IT/bash_it.sh"
