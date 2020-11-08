#!/usr/bin/env bash

# -------------------- Shell Variables ------------------- #
CDPATH=":~:"
HISTCONTROL="ignorespace:ignoredups"
HISTFILE="$HOME/.history/bash_history"
HISTSIZE="32768"
HISTFILESIZE=$HISTSIZE
HISTIGNORE="?:ls:[bf]g:pwd:clear*:exit*"
HISTTIMEFORMAT="%B %m %Y %T | "


# --------------------- Shell Options -------------------- #
# shopt
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
shopt -s nullglob
shopt -s progcomp
((${BASH_VERSION%%.*} == 5)) && shopt -s progcomp_alias # not working due to complete -D
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo # default

# set
set -o noclobber
set -o notify # deafult
set -o physical # default

# -------------------------- PS1 ------------------------- #
8BitColor() {
	test "$(tput colors)" -eq 8
}

24BitColor() {
	test "$COLORTERM" = "truecolor" || test "$COLORTERM" = "24bit"
}

if 24BitColor; then
	if test "$EUID" = 0; then
		PS1="\e[38;2;201;42;42m[\u@\h \w]\e[0m\$ "
	else
		eval "$(starship init bash)"
	fi
elif 8BitColor; then
	if test "$EUID" = 0; then
		PS1="\e[0;31m[\u@\h \w]\$\e[0m "
	else
		PS1="\e[0;33m[\u@\h \w]\$\e[0m "
	fi
else
	PS1="[\u@\h \w]\$ "
fi

unset -f 8BitColor
unset -f 24BitColor

# ---------------------- Completions --------------------- #
isCmd() {
	command -v "$1" >/dev/null 2>&1
}

[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

isCmd just && eval "$(just --completions bash)"
isCmd pack && source "$(pack completion)"
isCmd chezmoi && eval "$(chezmoi completion bash)"
isCmd poetry && eval "$(poetry completions bash)"


# pack
if [ "$(type -t compopt)" = "builtin" ]; then
	complete -o default -F __start_pack p
else
	complete -o default -o nospace -F __start_pack p
fi

# sudo
# uncomment to break autocomplete for sudo
#complete -cf sudo

unset -f isCmd


# ------------------------- Misc ------------------------- #
source "$XDG_CONFIG_HOME/bash/misc.sh"
source "$XDG_CONFIG_HOME/bash/bash-it.sh"


source "$XDG_CONFIG_HOME/broot/launcher/bash/br"
source ~/bin/z

export SDKMAN_DIR="/home/edwin/data/sdkman"
[ -s "$XDG_DATA_HOME/sdkman/bin/sdkman-init.sh" ] && source "$XDG_DATA_HOME/sdkman/bin/sdkman-init.sh"
