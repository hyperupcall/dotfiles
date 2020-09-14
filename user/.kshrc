#
# ~/.kshrc
#

test -r ~/.profile && . ~/.profile

HISTEDIT="$VISUAL"
HISTFILE="$HOME/.history/ksh_history"
HISTSIZE="32768"

set -o emacs
