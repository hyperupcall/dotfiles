#
# ~/.profile
#

## general ##
export VISUAL="nvim"
export EDITOR="$VISUAL"
export SUDO_EDITOR="$VISUAL"
export DIFFPROG="nvim -d"
export PAGER="less"
export LANG="${LANG:-en_US.UTF-8}"
export XDG_DATA_HOME="$HOME/.local/share" # default
export XDG_CONFIG_HOME="$HOME/.config" # default
export XDG_DATA_DIRS="/usr/local/share/:/usr/share" # default
export XDG_CONFIG_DIRS="/etc/xdg" # default
export XDG_CACHE_HOME="$HOME/.cache" # default
export PATH="$HOME/.local/bin:$PATH"


## core ##
# cp
alias cp="cp -i"

# df
alias df="df -h"

# free
alias free="free -m" 


## programs ##
# anki
alias anki='anki -b "$XDG_DATA_HOME/anki"'

# ansible
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible.cfg"

# atom
export ATOM_HOME="$XDG_DATA_HOME/atom"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

# bash-completeion
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash-completion/bash_completion"

# boto
export BOTO_CONFIG="$XDG_CONFIG_HOME/boto"

# buku
alias b="bukdu --suggest"

# bundle
export BUNDLE_CACHE_PATH="$XDG_CACHE_HOME/bundle"

# ccache
export CCACHE_DIR="$XDG_CACHE_HOME"/ccache
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME"/ccache.config

# dart
export PUB_CACHE="$XDG_CACHE_HOME/pub-cache"

# deno
export DENO_DIR="$XDG_DATA_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_DIR/bin"
export PATH="$DENO_INSTALL_ROOT:$PATH"
export PATH="$DENO_INSTALL_ROOT/bin:$PATH"

# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# dotdrop
alias dotdrop='dotdrop --cfg=$HOME/.dots/dotdrop.yaml'

# elinks
export ELINKS_CONFDIR="$XDG_DATA_HOME/elinks"

# flutter
export PATH="$HOME/.local/opt/flutter/bin:$PATH"

# gcloud
test -r "$HOME/.local/opt/google-cloud-sdk/path.bash.inc" && . "$HOME/.local/opt/google-cloud-sdk/path.bash.inc"
test -r "$HOME/.local/opt/google-cloud-sdk/completion.bash.inc" && . "$HOME/.local/opt/google-cloud-sdk/completion.bash.inc"

# gem
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem

# gitlib
export GITLIBS="$HOME/.local/opt/gitlibs"

# gnupg
alias gpg2='gpg2 --homedir "$XDG_DATA_HOME/gnupg"'
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
tty="$(tty)" && export GPG_TTY="$tty"; unset tty

# go
export GOROOT="$HOME/.local/opt/go/root"
export GOPATH="$HOME/.local/opt/go/path"
export PATH="$HOME/$GOPATH/bin:$PATH"

# gradle
export GRADLE_USER_HOME="$HOME/.local/opt/gradle"

# http-server
alias http-serve='http-serve -c-1 -a 127.0.0.1'

# ice authority
export ICEAUTHORITY="$XDG_RUNTIME_DIR/iceauthority"

# ipython
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter

# irssi
alias irssi='irssi --config "$XDG_CONFIG_HOME/irssi"'

# jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# krew
export KREW_ROOT="$HOME/.local/opt/krew"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# kubernetes
export KUBECONFIG="$XDG_DATA_HOME/kube"

# less
export LESS="-R"
export LESSKEY="$XDG_CONFIG_HOME/less/keys"
export LESSHISTFILE="$XDG_CONFIG_HOME/less/history"
export LESSHISTSIZE="250"
export LESS_TERMCAP_mb=$'\e[1;31m' # start blink
export LESS_TERMCAP_md=$'\e[1;36m' # start bold
export LESS_TERMCAP_me=$'\e[0m' # end all
export LESS_TERMCAP_so=$'\e[01;44;33m' # start reverse video
export LESS_TERMCAP_se=$'\e[0m' # end reverse video
export LESS_TERMCAP_us=$'\e[1;32m' # start underline
export LESS_TERMCAP_ue=$'\e[0m' # end underline

# ltrace
alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

# maven
alias mvn='mvn -gs "$XDG_CONFIG_HOME/maven/settings.xml"'

# most
export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

# mplayer
export MPLAYER_HOME=$XDG_CONFIG_HOME/mplayer

# mysql
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"

# n
export N_PREFIX="$HOME/.local/opt/n"
export PATH="$N_PREFIX/bin:$PATH"

# netbeams
alias netbeams='netbeans --userdir "$XDG_CONFIG_HOME/netbeans"'

# nnn
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# node
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"

# nvm
export NVM_DIR="$XDG_DATA_HOME"/nvm

# packer
export PACKER_CONFIG="$XDG_CONFIG_HOME/packerconfig"
export PACKER_CONFIG_DIR="$XDG_CONFIG_HOME/packer.d"

# pnpm
export NPM_CONFIG_STORE_DIR="$XDG_CONFIG_HOME/pnpm-store"

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# postgresql
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_CACHE_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"

# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$CARGO_HOME/bin:$PATH"

# rvm
test -r "$HOME/.rvm/scripts/rvm" && . "$HOME/.rvm/scripts/rvm"
export PATH="$HOME/.rvm/bin:$PATH"

# sccache
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"
export SCCACHE_CACHE_SIZE="20G"

# screen
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"

# snap
export PATH="/snap/bin:$PATH"

# stack
export STACK_ROOT="$XDG_DATA_HOME/stack"

# subversion
export SUBVERSION_HOME=$XDG_CONFIG_HOME/subversion

# terraform
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraformrc-custom"

# tmux
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# vagrant
export VAGRANT_HOME="$HOME/.local/opt/vagrant.d"
export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

# yarn
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
export PATH="$XDG_DATA_HOME/yarn/global/node_modules/.bin:$PATH"
