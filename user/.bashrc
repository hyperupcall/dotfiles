# shellcheck shell=bash
#
# ~/.bashrc
#

# for interactive, non-login shells. scp and rcp may still
# read this despite assumed noninteractivity - so ensure
# nothing gets printed to the tty

# shellcheck source=/dev/null
test -r ~/.profile && source ~/.profile

[[ $- != *i* ]] && return

hasColor() {
	test "$COLORTERM" = "truecolor"
}

# -------------------- Shell Variables ------------------- #
FCEDIT="$EDITOR" # default
HISTCONTROL="ignorespace:ignoredups"
HISTFILE="$HOME/.history/bash_history"
HISTSIZE="32768"
HISTFILESIZE=$HISTSIZE
HISTIGNORE="?:ls:[bf]g:pwd:clear*:exit*:* --help:* -h"
HISTTIMEFORMAT="%B %m %Y %T | "

# --------------------- Shell Options -------------------- #
# shopt
shopt -u autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize # default
shopt -s cmdhist # default
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globstar
shopt -s gnu_errfmt
shopt -s histappend
shopt -s histreedit
shopt -u hostcomplete
shopt -s interactive_comments # default
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -u progcomp
((${BASH_VERSION%%.*} == 5)) && shopt -s progcomp_alias # not working due to complete -D
shopt -u xpg_echo # default

# set
set -o noclobber
set -o notify # deafult
set -o physical # default

# -------------------------- PS1 ------------------------- #
if hasColor; then
	# color
	if test "$EUID" = 0; then
		PS1="\[\e[31m\][\u@\h \w]\$\[\e[m\] "
	else
		eval "$(starship init bash)"
	fi
else
	# no color
	if test "$EUID" = 0; then
		PS1="[\u@\h \w]\$ "
	else
		PS1="[\u@\h \W]\$ "
	fi
fi

# ------------------------- Misc ------------------------- #
source "$XDG_CONFIG_HOME/bash/misc.sh"
source "$XDG_CONFIG_HOME/bash/completion.sh"
source "$XDG_CONFIG_HOME/bash/bash-it.sh"

# ------------------------ Cleanup ----------------------- #
unset -f hasColor
