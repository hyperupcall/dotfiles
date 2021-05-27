unalias run-help

# TODO: zcompile
# autoload -Uz zcompile

# zmodload zsh/attr
# zmodload zsh/cap
# zmodload zsh/clone
zmodload zsh/compctl
zmodload zsh/complete
zmodload zsh/complist
zmodload zsh/computil
# zmodload zsh/curses
# zmodload zsh/datetime
# zmodload zsh/db/gdbm
# zmodload zsh/deltochar
# zmodload zsh/files
# zmodload zsh/langinfo
# zmodload zsh/mapfile
# zmodload zsh/mathfunc
# zmodload zsh/nearcolor
# zmodload zsh/newuser
# zmodload zsh/parameter
# zmodload zsh/pcre
# zmodload zsh/param/private
# zmodload zsh/regex
# zmodload zsh/sched
# zmodload zsh/net/socket
# zmodload zsh/stat
# zmodload zsh/system
# zmodload zsh/net/tcp
# zmodload zsh/termcap
# zmodload zsh/terminfo
# zmodload zsh/zftp
zmodload zsh/zle
zmodload zsh/zleparameter
# zmodload zsh/zprof
zmodload zsh/zpty
# zmodload zsh/zselelct
# zmodload zsh/util

typeset -U PATH path
# path=("$HOME/.local/bin" /other/things/in/path "$path[@]")

# TODO: compdump
autoload run-help
autoload zmv
autoload -Uz compinit
compinit
autoload -Uz edit-command-line run-help compinit zmv
autoload -Uz add-zsh-hook

autoload -RU colors && colors
autoload -RUz run-help
autoload -RUz run-help-git
autoload -RUz run-help-svn
autoload -RUz run-help-svk
autoload -RUz compinit promptinit
compinit
promptinit
zstyle ':completion:*' menu select
# zstyle ':completion::complete:*' gain-privileges 1
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# zstyle ':completion:*' rehash true

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
# prompt walters

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle 'calendar-file' "$HOME/data/zsh/calendar"

# By default, Ctrl+d will not close your shell if the command line is filled, this fixes it:
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

compinit


zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select

# Patterned history search with zsh expansion, globbing, etc.
bindkey -M vicmd '^T' history-incremental-pattern-search-backward
bindkey '^T' history-incremental-pattern-search-backward
bindkey -e
bindkey ' ' magic-space
# Verify search result before accepting
bindkey -M isearch '^M' accept-search

function zle-line-init zle-keymap-select {
	vimode=${${KEYMAP/vicmd/c}/main/i}
	zle reset-prompt
}

# ------------------------ Aliases ----------------------- #
alias help='run-help'

# basher
eval "$(basher init - zsh | grep -v 'export PATH')"

# direnv
eval "$(direnv hook zsh)"

# ------------------- precmd / postcmd ------------------- #
# precmd() {

# }

# Print the current running command's name to the window title.
preexec() {
	# for cdp()
	# shellcheck disable=SC2034
	_shell_cdp_dir="$PWD"
}
