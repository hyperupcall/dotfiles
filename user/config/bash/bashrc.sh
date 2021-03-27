# shellcheck shell=bash

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

# CDPATH=":~:"
HISTCONTROL="ignorespace:ignoredups"
HISTFILE="$HOME/.history/bash_history"
HISTSIZE="-1"
HISTFILESIZE="-1"
HISTIGNORE="ls:[bf]g:pwd:clear*:exit*:*sudo -S*:*sudo --stdin*"
HISTTIMEFORMAT="%B %m %Y %T | "
HISTTIMEFORMAT='%F %T ' # ISO 8601
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
shopt -s checkwinsize # default
shopt -s cmdhist # default
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -u hostcomplete
shopt -s interactive_comments # default
shopt -u mailwarn
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -u nullglob # setting obtains unexpected parameter expansion behavior
shopt -s progcomp
((${BASH_VERSION%%.*} == 5)) && shopt -s progcomp_alias # not working due to complete _D
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo # default

# -------------------------- set ------------------------- #
set -o noclobber
set -o notify # deafult
set -o physical # default


#
# ─── PS1 ────────────────────────────────────────────────────────────────────────
#

8Colors() {
	test "$(tput colors)" -eq 8
}

256Colors() {
	test "$(tput colors)" -eq 256
}

16MillionColors() {
	test "$COLORTERM" = "truecolor" || test "$COLORTERM" = "24bit"
}

if 16MillionColors; then
	if test "$EUID" = 0; then
		PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]\$ "
	else
		source "$(type -P fox-default)" launch bash-prompt || {
			PS1="[\[\e[0;31m\](PS1 Error)\[\e[0m\] \u@\h \w]\$ "
		}
	fi
elif 8Colors || 256Colors; then
	if test "$EUID" = 0; then
		PS1="\[\e[0;31m\][\u@\h \w]\[\e[0m\]\$ "
	else
		PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]\$ "
	fi
else
	PS1="[\u@\h \w]\$ "
fi

unset -f 8Colors 256Colors 16MillionColors


#
# ─── READLINE ───────────────────────────────────────────────────────────────────
#

source "$XDG_CONFIG_HOME/bash/readline.sh"


#
# ─── MISCELLANEOUS ──────────────────────────────────────────────────────────────
#

# bash_completion (also sources $XDG_CONFIG_HOME/bash/bash_completions (as per env variable))
# not needed as we `source /etc/profile` at beginnning of script
# [ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# bashmarks
# SDIRS="$XDG_DATA_HOME/bashmarks.sh.db"
# [ -r ~/.local/bin/bashmarks.sh ] && source ~/.local/bin/bashmarks.sh

# dircolors
[ -r "$XDG_CONFIG_HOME/dircolors/dir_colors" ] && eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# direnv
eval "$(direnv hook bash)"
