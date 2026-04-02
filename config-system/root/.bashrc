# shellcheck shell=bash
# Stop execution if bash is non-interactive.
[[ $- != *i* ]] && [ ! -t 0 ] && return

# Ensure /etc/profile is read for non-login shells.
# Bash only reads /etc/profile on interactive, login shells.
# ! shopt -q login_shell && [ -f /etc/profile ] && source /etc/profile

# Ensure ~/.profile is read for non-login shells.
# Bash only reads ~/.profile on login shells when invoked as sh.
[ -f ~/.profile ] && source ~/.profile

# Set shell variables.
HISTCONTROL=ignoredups:ignorespace
HISTSIZE='-1'
HISTFILESIZE='-1'

# Set bash options.
shopt -s checkwinsize
shopt -s histappend

# PS1.
if [ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]; then
	PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]# "
else
	_colors=$(tput colors 2>/dev/null)
	if [ -n "$_colors" ] && (( _colors == 8 || _colors == 256)); then
		PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]# "
	else
		PS1="[\u@\h \w]# "
	fi
	unset -v _colors
fi

# Additional customizations.
if  command -v dircolors &>/dev/null && [ -f ~/.dir_colors ]; then
	eval "$(dircolors ~/.dir_colors)"
fi
