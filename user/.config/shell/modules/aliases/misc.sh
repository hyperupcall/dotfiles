# shellcheck shell=sh

alias aria2c='aria2c -d "$HOME/Docs/App/aria2c"'
alias b='bukdu --suggest'
alias but='btrfs'
alias cat='cat -v' # clone(user, root)
alias cmd='command' # clone(user, root)
alias cmdv='command -v' # clone(user, root)
alias cmdV='command -V' # clone(user, root)
alias copy='xclip -selection clipboard'
alias ddad='dragon-drag-and-drop'
alias gg='command g'
alias gglue='"$HOME/repos/glue/pkg/bin/glue"'
alias hexdump='od -A x -t x1z -v'
alias ipa='command ip -c -br a'
alias j='just' # clone(user, root)
alias kssh='kitty +kitten ssh'
alias l='exa -al --icons --git' # clone(user, root)
alias la='exa -a' # clone(user, root)
alias ll='exa -al --icons --git' # clone(user, root)
alias mp='mountpoint' # clone(user, root)
alias pbat='bat -p' # clone(user, root)
alias tbat='bat --pager "\"$PAGER\" +G"' # clone(user, root)
alias rbat='tbat'
alias piup='pip install --upgrade pip' # clone(user)
alias psa='ps xawf -eo pid,user,cgroup,args'
alias rm!='command rm -rf'
alias rmrf='command rm -rf' # clone(user, root)
alias rmrfv='command rm -rfv' # clone(user, root)
alias run-help='help' # clone(user, root)
alias new-venv='python -m venv .venv && source .venv/bin/activate && pip install wheel && piup'
alias ta='type -a' # clone(user, root)
alias utc='TZ=UTC date'
alias ydl='youtube-dl' # clone(user)
alias partusage='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs'
alias totalusage='df -hl --total | grep total'
alias totalusage='df -hl --total | grep total'
