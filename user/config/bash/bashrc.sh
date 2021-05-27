# shellcheck shell=bash
#
# ~/.bashrc
#

# ensure execution returns if bash is non-interactive
[[ $- != *i* ]] && [ ! -t 0 ] && return

# ensure /etc/profile is read for non-login shells
# bash only reads /etc/profile on interactive, login shells
! shopt -q login_shell && [ -r /etc/profile ] && source /etc/profile

# ensure ~/.profile is read for non-login shells
# bash only reads ~/.profile on login shells when invoked as sh
[ -r ~/.profile ] && source ~/.profile


#
# ─── FRAMEWORKS ─────────────────────────────────────────────────────────────────
#

# source "$XDG_CONFIG_HOME/bash/frameworks/oh-my-bash.sh"
# source "$XDG_CONFIG_HOME/bash/frameworks/bash-it.sh"


#
# ─── SHELL VARIABLES ────────────────────────────────────────────────────────────
#

# exported so virtual environments inherit the new values

# export CDPATH=":~:"
export HISTCONTROL="ignorespace:ignoredups"
export HISTFILE="$HOME/.history/bash_history"
export HISTSIZE="-1"
export HISTFILESIZE="-1"
export HISTIGNORE="ls:[bf]g:pwd:clear*:exit*:*sudo*-S*:*sudo*--stdin*"
export HISTTIMEFORMAT="%B %m %Y %T | "
export HISTTIMEFORMAT='%F %T ' # ISO 8601
unset MAILCHECK
PROMPT_DIRTRIM=5


#
# ─── SHELL OPTIONS ──────────────────────────────────────────────────────────────
#

# ------------------------- shopt ------------------------ #
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -u hostcomplete
shopt -s interactive_comments
shopt -u mailwarn
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -u nullglob # setting obtains unexpected parameter expansion behavior
shopt -s progcomp
((${BASH_VERSION%%.*} == 5)) && shopt -s progcomp_alias # not working due to complete -D
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo

# -------------------------- set ------------------------- #
set -o noclobber
set -o notify
set -o physical


#
# ─── PS1 ────────────────────────────────────────────────────────────────────────
#

is8Colors() {
	colors="$(tput colors 2>/dev/null)"

	[ -n "$colors" ] && [ "$colors" -eq 8 ]
}

is256Colors() {
	colors="$(tput colors 2>/dev/null)"

	[ -n "$colors" ] && [ "$colors" -eq 256 ]
}

is16MillionColors() {
	[ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]
}

if is16MillionColors; then
	if ((EUID == 0)); then
		PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]\$ "
	else
		# shellcheck disable=SC3046
		source "$(command -v choose)" launch prompt-bash || {
			PS1="[\[\e[0;31m\](PS1 Error)\[\e[0m\] \u@\h \w]\$ "
		}
	fi
elif is8Colors || is256Colors; then
	if ((EUID == 0)); then
		PS1="\[\e[0;31m\][\u@\h \w]\[\e[0m\]\$ "
	else
		PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]\$ "
	fi
else
	PS1="[\u@\h \w]\$ "
fi

unset -f is8Colors is256Colors is16MillionColors


#
# ─── MODULES ────────────────────────────────────────────────────────────────────
#

source "$XDG_CONFIG_HOME/bash/modules/readline.sh"
source "$XDG_CONFIG_HOME/bash/modules/miscellaneous.sh"

# -----
