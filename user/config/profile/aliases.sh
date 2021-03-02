# shellcheck shell=sh

# overwrides
alias du='dust'
alias lsblk='duf'
alias ping='mtr'
alias traceroute='mtr'

# general
alias cd-='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias cp='cp -i'
alias dd='dd status=progress'
alias diff='diff --color=auto'
alias dir='dir --color=auto'
alias df='df -h'
alias du='du -h'
alias egrep='egrep --colour=auto'
alias feh='feh --no-fehbg'
alias fgrep='fgrep --colour=auto'
alias free='free -m'
alias g='git'
alias grep='grep --colour=auto'
alias ip='ip -color=auto'
alias j='just'
alias kssh='kitty +kitten ssh'
alias mkdir='mkdir -p'
alias pacman='pacman --color=auto'
alias p7zip='p7zip -k'
alias rm='rm --preserve-root=all'
alias speedtest-cli='speedtest-cli --secure'
alias sudo='sudo ' # sudo aliases `info bash -n Aliases`
alias tree='tree -h'
alias vdir='vdir --color=auto'
alias xz='xz -k'
alias yay='yay --color=auto'

# general (changed functionality)
alias b='bukdu --suggest'
alias copy='xclip -selection clipboard'
alias ded='vim ~/config/dotty'
alias la='exa -a'
alias ll='exa -al --icons'
alias ls='ls --color=auto -hF'
alias mr='trash-put'
alias psa='ps xawf -eo pid,user,cgroup,args'
alias t='todo.sh'
alias tp='trash-put'

# shell / bash
alias pso='. ~/.profile'
alias ped='"$EDITOR" "$XDG_CONFIG_HOME/profile"'
alias bso='. ~/.bashrc'
alias bed='"$EDITOR" "$XDG_CONFIG_HOME/bash/bashrc.sh"'

# systemd
alias ssstatus='systemctl --system status'
alias ssstart='systemctl --system start'
alias ssstop='systemctl --system stop'
alias ssr='systemctl --system restart'
alias ssn='systemctl --system enable'
alias sse='systemctl --system edit --full'
alias sustatus='systemctl --user status'
alias sustart='systemctl --user start'
alias sustop='systemctl --user stop'
alias sur='systemctl --user restart'
alias sun='systemctl --user enable'
alias sue='systemctl --user edit --full'

# journalctl
alias ju='journalctl --system -b -u'
alias juu='journalctl --user -b -u'

# git
alias gclone='git clone'
alias gpull='git pull --all'
alias gpush='git push'
alias gstatus='git status'
