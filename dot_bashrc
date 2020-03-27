# for interactive non-login shells
test -r ~/.profile || return && source ~/.profile

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

## variables ##
CDPATH=":~:/usr/local"
FCEDIT="$EDITOR" # default
HISTCONTROL="ignorespace,ignoredups"
HISTFILE="$XDG_DATA_HOME/bash_history"
HISTSIZE="5000"
HISTIGNORE="?:ls:[bf]g:exit:pwd:clear"
HISTTIMEFORMAT="%T %B %m %Y | "
INPUTRC="$XDG_CONFIG_HOME/inputrc"

## options ##
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

set -o notify # deafult
set -o physical # default

## colors ##
command -v tput >/dev/null && nc="$(tput colors)"
if test -n "$nc" && test "$nc" -ge 256 ; then
    export PS1="\[\033[38;5;88m\][\[$(tput sgr0)\]\[\033[38;5;23m\]\u\[$(tput sgr0)\]\[\033[38;5;166m\]@\[$(tput sgr0)\]\[\033[38;5;23m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;166m\]\W\[$(tput sgr0)\]\[\033[38;5;88m\]]\[$(tput sgr0)\]\[\033[38;5;23m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

    if command -v dircolors >/dev/null ; then
        if test -f ~/.dir_colors ; then
            eval "$(dircolors -b '$XDG_CONFIG_HOME/dir_colors')"
        fi
    fi

    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
fi
unset nc


# sanitize term
safe_term=${TERM//[^[:alnum:]]/?}

# x11
xhost +local:root >/dev/null 2>&1


## bash completions ##
test -r /usr/share/bash-completion/bash_completion && . /usr/share/bash-completion/bash_completion

# sudo
complete -cf sudo

# buildpacks
command -v pack > /dev/null && source $(pack completion)
alias p="pack"
if [ $(type -t compopt) = "builtin" ]; then
  complete -o default -F __start_pack p
else
  complete -o default -o nospace -F __start_pack p
fi

# chezmoi (github.com/twpayne/chezmoi)
command -v chezmoi > /dev/null && eval "$(chezmoi completion bash)"

# travis
test -f /home/edwin/.travis/travis.sh && source "$HOME/.travis/travis.sh"

# poetry (github.com/python-poetry/poetry)
command -v poetry >/dev/null && eval "$(poetry completions bash)"

