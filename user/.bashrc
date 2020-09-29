# shellcheck shell=bash
#
# ~/.bashrc
#

# for interactive, non-login shells. scp and rcp may still
# read this despite assumed noninteractivity - so ensure
# nothing gets printed to the tty

# if profile can be read, source it
# shellcheck source=/dev/null
test -r ~/.profile && source ~/.profile

# if not running interactively, exit
[[ $- != *i* ]] && return

# only enable colors for terminals that support true color
hasColor() {
	test "$COLORTERM" = "truecolor"
}

# -------------------- shell variables ------------------- #
FCEDIT="$EDITOR" # default
HISTCONTROL="ignorespace:ignoredups"
HISTFILE="$HOME/.history/bash_history"
HISTSIZE="32768"
HISTFILESIZE=$HISTSIZE
HISTIGNORE="?:ls *:[bf]g:pwd:clear*:exit*:* --help:* -h"
HISTTIMEFORMAT="%T %B %m %Y | "
INPUTRC="$XDG_CONFIG_HOME/inputrc"

# --------------------- shell options -------------------- #
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
shopt -u hostcomplete
shopt -s interactive_comments # default
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -u progcomp
shopt -s progcomp_alias # not working due to complete -D interference?
shopt -u xpg_echo # default

# set
set -o notify # deafult
set -o physical # default

# ------------------------ colors ------------------------ #
# dir_colors
if hasColor; then
	test -r "$XDG_CONFIG_HOME/dir_colors" \
		&& eval "$(dircolors -b "$XDG_CONFIG_HOME/dir_colors")"
else
	unset LS_COLORS
fi

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


# ---------------------- completion ---------------------- #
# bash_completion
# shellcheck source=/usr/share/bash-completion/bash_completion
test -r /usr/share/bash-completion/bash_completion && . /usr/share/bash-completion/bash_completion

# pack
if [ "$(type -t compopt)" = "builtin" ]; then
	complete -o default -F __start_pack p
else
	complete -o default -o nospace -F __start_pack p
fi

# buildpacks
# shellcheck source=/dev/null
command -v pack >/dev/null && source "$(pack completion)"

# chezmoi
command -v chezmoi >/dev/null && eval "$(chezmoi completion bash)"

# poetry
command -v poetry >/dev/null && eval "$(poetry completions bash)"


# ------------------------- etc ------------------------- #

# sudo
complete -cf sudo

# travis
# shellcheck source=/dev/null
test -f /home/edwin/.travis/travis.sh && source "$HOME/.travis/travis.sh"

# x11
xhost +local:root >/dev/null 2>&1

eval $(gnome-keyring-daemon -s)


# ------------------------ cleanup ----------------------- #
unset -f hasColor
