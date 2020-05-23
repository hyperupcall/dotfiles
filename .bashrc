#
# ~/.bashrc
# interactive, non-login shells
# 

# if profile can be read, source it; else exit
test -r ~/.profile || return && source ~/.profile

# if not running interactively, exit
[[ $- != *i* ]] && return

# if terminal does not enable truecolor, exit
test "$COLORTERM" = "truecolor" || return

## shell variables ##
CDPATH=":~:/usr/local"
FCEDIT="$EDITOR" # defaultK
HISTCONTROL="ignorespace,ignoredups"
HISTFILE="$XDG_DATA_HOME/bash_history"
HISTSIZE="5000"
HISTIGNORE="?:ls:[bf]g:exit:pwd:clear"
HISTTIMEFORMAT="%T %B %m %Y | "
INPUTRC="$XDG_CONFIG_HOME/inputrc"

## shell options ##
# shopt
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize # default
shopt -s cmdhist # default
shopt -s dirspell
shopt -s failglob
shopt -s globstar
shopt -s gnu_errfmt
shopt -s histappend
shopt -u hostcomplete
shopt -s interactive_comments # default
shopt -s nocaseglob
shopt -s nocasematch
shopt -s progcomp_alias # not working due to complete -D interference?
shopt -u xpg_echo # default

# set
set -o notify # deafult
set -o physical # default

## core ##
# diff
alias diff='diff --color=auto'

# egrep
alias egrep='egrep --colour=auto'

# fgrep
alias fgrep='fgrep --colour=auto'

# grep
alias grep='grep --colour=auto'

# ip
alias ip='ip -color=auto'

# ls
alias ls='ls --color=auto'

# sudo
complete -cf sudo


## programs
## bash completions ##
test -r /usr/share/bash-completion/bash_completion && . /usr/share/bash-completion/bash_completion

# buildpacks
command -v pack >/dev/null && source $(pack completion)

# chezmoi
command -v chezmoi >/dev/null && eval "$(chezmoi completion bash)"

# poetry
command -v poetry >/dev/null && eval "$(poetry completions bash)"

# travis
test -f /home/edwin/.travis/travis.sh && source "$HOME/.travis/travis.sh"

# x11
xhost +local:root >/dev/null 2>&1


## crap i still have to cleanup
if [ $(type -t compopt) = "builtin" ]; then
  complete -o default -F __start_pack p
else
  complete -o default -o nospace -F __start_pack p
fi

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash || true

eval $(keychain --eval --quiet)

## colors ##
nc="$(tput colors)"
if command -v dircolors >/dev/null ; then
    if test -f ~/.dir_colors ; then
        eval "$(dircolors -b '$XDG_CONFIG_HOME/dir_colors')"
    fi
fi
unset nc

export PS1="\[\033[38;5;88m\][\[$(tput sgr0)\]\[\033[38;5;23m\]\u\[$(tput sgr0)\]\[\033[38;5;166m\]@\[$(tput sgr0)\]\[\033[38;5;23m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;166m\]\W\[$(tput sgr0)\]\[\033[38;5;88m\]]\[$(tput sgr0)\]\[\033[38;5;23m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
