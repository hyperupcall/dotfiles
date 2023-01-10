# shellcheck shell=sh

# ------------------------ tweaks ------------------------ #
alias cd-='cd ~-'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..l='cd .. && ll'
alias ...l='cd ../.. && ll'
alias ....l='cd ../../.. && ll'
alias bzip2='bzip2 -k'
alias chmod='chmod -c --preserve-root'
alias chown='chown -c --preserve-root'
alias chgrp='chgrp -c --preserve-root'
# alias cp='cp -iv'
alias dd='dd status=progress'
alias diff='diff --color=auto'
alias dir='dir --color=auto'
alias dmesg='dmesg -ex'
alias dmesgw='dmesg -exw'
alias df='df -h'
alias du='du -h'
alias egrep='egrep --colour=auto'
alias feh='feh --no-fehbg'
alias fgrep='fgrep --colour=auto'
alias free='free -m'
alias gdb='gdb -nh -x "$XDG_CONFIG_HOME/gdb/gdbinit"'
alias grep='grep --colour=auto'
alias gzip='gzip -k'
alias ip='ip -color=auto'
alias ln='ln -v'
alias locate='locate -i'
alias ls='ls --color=auto -hF'
alias mkdir='mkdir -p'
# alias mv='mv -v'
alias pacman='pacman --color=auto'
alias paru='paru --color=auto'
alias p7zip='p7zip -k'
alias rm='rm -dI --preserve-root=all'
alias rsync='rsync --verbose --archive --info=progress2 --human-readable --partial'
alias speedtest-cli='speedtest-cli --secure'
alias sudo='sudo ' # sudo aliases `info bash -n Aliases`
alias tree='tree -a --dirsfirst -h'
alias vdir='vdir --color=auto'
alias xz='xz -k'
# alias yay='yay --color=auto'


# -------------------------- git ------------------------- #
alias g='git'
alias ginit='git init'
alias gclone='git clone'
# gclonedir shell function
alias gpull='git pull'
alias gpush='git push'
alias gstatus='git status'
alias gcommit='git commit'


# ----------------------- systemctl ---------------------- #
alias sctl='systemctl'
alias sctlu='systemctl --user'
alias ctl='systemctl'
alias ctlu='systemctl --user'

# unit commands
alias ctlslu='systemctl --system list-units'
alias ctlsls='systemctl --system list-sockets'
alias ctlslt='systemctl --system list-timers'
alias ctlsia='systemctl --system is-active'
alias ctlsif='systemctl --system is-failed'
alias ctlss='systemctl --system status'
alias ctlsstatus='systemctl --system status'
alias ctlsshow='systemctl --system show'
alias ctlsc='systemctl --system cat'
alias ctlscat='systemctl --system cat'
alias ctlshelp='systemctl --system help'
alias ctlsld='systemctl --system list-dependencies'
alias ctlsstart='systemctl --system start'
alias ctlsstop='systemctl --system stop'
alias ctlsreload='systemctl --system reload'
alias ctlsr='systemctl --system restart'
alias ctlsrestart='systemctl --system restart'

# unit file commands
alias ctlsluf='systemctl --system list-unit-files'
alias ctlsdr='systemctl --system daemon-reload'
alias ctlsn='systemctl --system enable'
alias ctlsenable='systemctl --system enable'
alias ctlsd='systemctl --system disable'
alias ctlse='systemctl --system edit --full'

# unit commands
alias ctlulu='systemctl --user list-units'
alias ctluls='systemctl --user list-sockets'
alias ctlult='systemctl --user list-timers'
alias ctluia='systemctl --user is-active'
alias ctluif='systemctl --user is-failed'
alias ctlus='systemctl --user status'
alias ctlustatus='systemctl --user status'
alias ctlushow='systemctl --user show'
alias ctluc='systemctl --user cat'
alias ctlucat='systemctl --user cat'
alias ctluhelp='systemctl --user help'
alias ctluld='systemctl --user list-dependencies'
alias ctlustart='systemctl --user start'
alias ctlustop='systemctl --user stop'
alias ctlureload='systemctl --user reload'
alias ctlur='systemctl --user restart'
alias ctlurestart='systemctl --user restart'

# unit file commands
alias ctluluf='systemctl --user list-unit-files'
alias ctludr='systemctl --user daemon-reload'
alias ctlun='systemctl --user enable'
alias ctluenable='systemctl --user enable'
alias ctlud='systemctl --user disable'
alias ctlue='systemctl --user edit --full'


# ---------------------- journalctl ---------------------- #
alias jctl='journalctl'
alias ju='journalctl --user -b -eu'
alias js='journalctl --system -b -eu'


# ------------------------- *ctl ------------------------- #
alias bctl='busctl'
alias btctl='bluetoothctl'
alias cdctl='coredumpctl'
alias hctl='hostnamectl'
alias hnctl='hostnamectl'
alias lcctl='localectl'
alias lgctl='loginctl'
alias lctl='loginctl'
alias mctl='machinectl'
alias pctl='portablectl'
alias rctl='resolvectl'
alias tdctl='timedatectl'


# ------------------------ shells ------------------------ #
alias sop='. ~/.profile'
alias sob='. ~/.bashrc'
alias edp='"$EDITOR" "$XDG_CONFIG_HOME/shell/profile.sh"'
alias edb='"$EDITOR" "$XDG_CONFIG_HOME/bash/bashrc.sh"'

alias pso='. ~/.profile'
alias ped='"$EDITOR" "$XDG_CONFIG_HOME/shell/profile.sh"'
alias bso='. ~/.bashrc'
alias bed='"$EDITOR" "$XDG_CONFIG_HOME/bash/bashrc.sh"'

# -------------------------- apt ------------------------- #
alias aptup='sudo apt update'
alias aptug='sudo apt upgrade'
alias aptfug='sudo apt full-upgrade'
alias apti='sudo apt install'
alias aptri='sudo apt reinstall'
alias aptrei='sudo apt reinstall'
alias aptrem='sudo apt remove'
alias aptp='sudo apt purge'
alias aptse='apt search'
alias aptsh='apt show'
alias aptl='apt list'

# ------------------------- dpkg ------------------------- #
alias dl='dpkg -l'
alias dW='dpkg -W'
alias ds='dpkg -s'
alias dL='dpkg -L'
alias dS='dpkg -S'
alias dp='dpkg -p'

# ------------------------- pass ------------------------- #
alias pl='pass ls'
alias pf='pass find'
# alias ps='pass show'
alias pg='pass grep'
alias pi='pass insert'
alias pe='pass edit'
alias pg='pass generate'
alias pgn='pass generate -n'
alias pr='pass remove'

