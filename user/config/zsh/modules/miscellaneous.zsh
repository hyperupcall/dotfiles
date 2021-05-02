unalias run-help

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

# TODO: compdump
autoload run-help
autoload zmv
autoload -U compinit
autoload -Uz edit-command-line run-help compinit zmv

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle 'calendar-file' "$HOME/data/zsh/calendar"

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


# ------------------- precmd / postcmd ------------------- #
precmd() {

}

# Print the current running command's name to the window title.
preexec() {
	printf '\e]2;%s\a' "$1"
}
