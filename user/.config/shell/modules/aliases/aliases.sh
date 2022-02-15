# shellcheck shell=sh

# ------------------------ tweaks ------------------------ #
alias cd-='cd -'
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

# unit commands
alias sslu='systemctl --system list-units'
alias ssls='systemctl --system list-sockets'
alias sslt='systemctl --system list-timers'
alias ssia='systemctl --system is-active'
alias ssif='systemctl --system is-failed'
alias sss='systemctl --system status'
alias ssstatus='systemctl --system status'
alias ssshow='systemctl --system show'
alias ssc='systemctl --system cat'
alias sscat='systemctl --system cat'
alias sshelp='systemctl --system help'
alias ssld='systemctl --system list-dependencies'
alias ssstart='systemctl --system start'
alias ssstop='systemctl --system stop'
alias ssreload='systemctl --system reload'
alias ssr='systemctl --system restart'
alias ssrestart='systemctl --system restart'

# unit file commands
alias ssluf='systemctl --system list-unit-files'
alias ssdr='systemctl --system daemon-reload'
alias ssn='systemctl --system enable'
alias ssenable='systemctl --system enable'
alias ssd='systemctl --system disable'
alias sse='systemctl --system edit --full'

# unit commands
alias sulu='systemctl --user list-units'
alias suls='systemctl --user list-sockets'
alias sult='systemctl --user list-timers'
alias suia='systemctl --user is-active'
alias suif='systemctl --user is-failed'
alias sus='systemctl --user status'
alias sustatus='systemctl --user status'
alias sushow='systemctl --user show'
alias suc='systemctl --user cat'
alias sucat='systemctl --user cat'
alias suhelp='systemctl --user help'
alias suld='systemctl --user list-dependencies'
alias sustart='systemctl --user start'
alias sustop='systemctl --user stop'
alias sureload='systemctl --user reload'
alias sur='systemctl --user restart'
alias surestart='systemctl --user restart'

# unit file commands
alias suluf='systemctl --user list-unit-files'
alias sudr='systemctl --user daemon-reload'
alias sun='systemctl --user enable'
alias suenable='systemctl --user enable'
alias sud='systemctl --user disable'
alias sue='systemctl --user edit --full'


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

# apt # TODO: comment line
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

# dpkg # TODO: comment line
alias dl='dpkg -l'
alias dW='dpkg -W'
alias ds='dpkg -s'
alias dL='dpkg -L'
alias dS='dpkg -S'
alias dp='dpkg -p'
