autoload run-help
alias help='run-help'

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'


SAVEHIST=2147483647
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

HISTFILE="$XDG_STATE_HOME/history/zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^R' history-incremental-search-backward
