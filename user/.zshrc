#
# ~/.zshrc
# interactive non-login shells
#

# if profile can be read; source it; else exit
test -x ~/.zprofile || return && source ~/.zprofile

# if not running interactively, exit
[[ $- != *i* ]] && return

# if terminal does not enable truecolor, exit
test "$COLORTERM" = "truecolor" || return

## shell variables ##
FCEDIT="$EDITOR" # default
HISTFILE="$HOME/.history/zsh_history"
HISTSIZE="32768"
SAVEHIST="5000"
WORDCHARS=${WORDCHARS//\/[&.;]}

## shell options ##
# changing directories
setopt autocd
setopt auto_pushd
setopt cdable_vars
setopt cdsilent
setopt chase_dots
setopt chase_links # bash physical
setopt posixcd
setopt pushd_ignore_dups
unsetopt pushd_to_home

# expansion and globbing
setopt bad_pattern
unsetopt case_glob
unsetopt case_match

# history
setopt append_history # default; bash histappend
setopt extended_history
unset hist_beep
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt inc_append_history_time
setopt share_history

# misc
unsetopt global_export
setopt correct
setopt extended_glob
setopt numericglobsort
setopt rc_expand_param
setopt prompt_subst
unsetopt beep

compinit -d <dumpfile>

## styles ##
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache


## keybindings ##
bindkey -e
bindkey '^[[7~' beginning-of-line
bindkey '^[[H' beginning-of-line
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
fi
bindkey '^[[8~' end-of-line
bindkey '^[[F' end-of-line
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line
fi
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[C'  forward-char
bindkey '^[[D'  backward-char
bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward


autoload -U compinit colors zcalc
compinit -d
colors

## plugins section: Enable fish style features
# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source ~/.config/zsh/oh-my-zsh.zsh
