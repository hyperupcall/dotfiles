# shellcheck shell=sh

alias b='bukdu --suggest'
alias cliflix='cliflix -- --no-quit --vlc'
alias g='git'
alias j=just
alias la='exa -a'
alias ll='exa -al --icons'
alias ls='ls -h'
alias mkdir='mkdir -p'
alias p7zip='p7zip -k'
alias ping='ping -c 5'
alias psa='ps xawf -eo pid,user,cgroup,args'
alias r='trash-put'
#rm()if command -v trash-rm >/dev/null 2>&1; then trash-rm "$@"; else rm "$@" fi
#rm() { type trash-rm >/dev/null 2>&1 && { trash-rm "$@"; true } || rm "$@" }
# sudo (sudo alises; see `info bash -n Aliases` for details)
alias rm='rm --preserve-root=all'
alias speedtest-cli='speedtest-cli --secure'
alias sudo='sudo '
alias t='todo.sh'
alias xz='xz -k'
alias d='duf'
alias vdir='vdir --color=auto'

alias pso='. ~/.profile'
alias ped='"$EDITOR" "$XDG_CONFIG_HOME/profile"'
alias bso='. ~/.bashrc'
alias bed='"$EDITOR" "$XDG_CONFIG_HOME/bash/bashrc.sh"'

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

alias ju='journalctl --system -b -u'
alias juu='journalctl --user -b -u'

alias cbc='xclip -selection clipboard'
