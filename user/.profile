# shellcheck shell=sh
#
# ~/.profile
#

umask 022

# -------------------- shell variables ------------------- #
CDPATH=":~:/usr/local"
export VISUAL="vim"
export EDITOR="$VISUAL"
export DIFFPROG="nvim -d"
export PAGER="less"
export BROWSER="brave-beta"
export LANG="${LANG:-en_US.UTF-8}k"
export SPELL="aspell -x -c"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

export XDG_DATA_HOME="$HOME/data"
export XDG_CONFIG_HOME="$HOME/config"
export XDG_CACHE_HOME="$HOME/.cache" # default

# ----------------------- programs ----------------------- #
# anki
alias anki='anki -b "$XDG_DATA_HOME/anki"'

# atom
export ATOM_HOME="$XDG_DATA_HOME/atom"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_DATA_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_DATA_HOME/aws/config"

# bash-completeion
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash-completion/bash_completion"

# boto
export BOTO_CONFIG="$XDG_DATA_HOME/boto"

# buku
alias b='bukdu --suggest'

# bundle
export BUNDLE_USER_HOME="$XDG_DATA_HOME/bundle"
export BUNDLE_CACHE_PATH="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# ccache
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME/ccache/config"

# chmod
alias chmod='chmod --preserve-root'

# chown
alias chown='chown --preserve-root'

# cp
alias cp='cp -i'

# cuda
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

# curl
alias curl='curl --config $XDG_CONFIG_HOME/curl/curlrc'

# dart
export PUB_CACHE="$XDG_CACHE_HOME/pub-cache"

# dd
alias dd='dd --status=progress'

# deno
export DENO_INSTALL="$XDG_DATA_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_INSTALL/bin"
export PATH="$DENO_INSTALL_ROOT:$PATH"
export PATH="$DENO_INSTALL_ROOT/bin:$PATH"

# diff
alias diff='diff --color=auto'

# dir
alias dir='dir --color=auto'

# df
alias df='df -h'

# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# du
alias du='du -h'

# dotty
alias dotty='dotty --dot-dir=$HOME/.dots'

# egrep
alias egrep='egrep --colour=auto'

# elinks
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"

# feh
alias feh='feh --no-fehbg'

# fgrep
alias fgrep='fgrep --colour=auto'

# free
alias free='free -m'

# g
export GOPATH="$XDG_DATA_HOME/go-path"
export PATH="$GOPATH/bin:$PATH"

# gem
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

# gitlib
export GITLIBS="$HOME/.local/opt/gitlibs"

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
tty="$(tty)" && export GPG_TTY="$tty"
unset -v tty

# grep
alias grep='grep --colour=auto'

# git
export GIT_CONFIG_NOSYSTEM=

# gradle
export GRADLE_USER_HOME="$HOME/.local/opt/gradle"

# gtk
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# http-server
alias http-serve='http-serve -c-1 -a 127.0.0.1'

# ice authority
export ICEAUTHORITY="$XDG_RUNTIME_DIR/iceauthority"

# imap
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"

# ip
alias ip='ip -color=auto'

# info
alias info='info --init-file $XDG_CONFIG_HOME/info/infokey'

# ipython
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter

# irssi
alias irssi='irssi --config "$XDG_CONFIG_HOME/irssi"'

# junest
export JUNEST_HOME="$HOME/.local/opt/junest"

# jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# kde
export KDEHOME="$XDG_CONFIG_HOME/kde"

# krew
export KREW_ROOT="$HOME/.local/opt/krew"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# kubernetes
export KUBECONFIG="$XDG_DATA_HOME/kube"

# less
# adding X breaks mouse scrolling of pages
export LESS="-FIRQ"
# export LESS="-FIRX"
export LESSKEY="$XDG_CONFIG_HOME/less_keys"
export LESSHISTFILE="$HOME/.history/less_history"
export LESSHISTSIZE="$common_histsize"
LESS_TERMCAP_mb="$(printf '\e[1;31m')" # start blink
LESS_TERMCAP_md="$(printf '\e[1;36m')" # start bold
LESS_TERMCAP_me="$(printf '\e[0m')" # end all
LESS_TERMCAP_so="$(printf '\e[01;44;33m')" # start reverse video
LESS_TERMCAP_se="$(printf '\e[0m')" # end reverse video
LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
LESS_TERMCAP_ue="$(printf '\e[0m')" # end underline
LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me \
	LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us \
	LESS_TERMCAP_ue LESS_TERMCAP_us

# loginctl
alias lctl='loginctl terminate-session'

# ls
alias la='exa -a'
alias ll='exa -al'
alias ls='ls --color=auto'

# ltrace
alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

# mongo
alias mongo='mongo --norc'

# more
export MORE="--silent"

# most
export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

# mplayer
export MPLAYER_HOME="$XDG_DATA_HOME/mplayer"

# mysql
export MYSQL_HISTFILE="$HOME/.history/mysql_history"

# n
export N_PREFIX="$XDG_DATA_HOME/n"
export PATH="$N_PREFIX/bin:$PATH"

# netbeams
# alias netbeams='netbeans --userdir "$XDG_CONFIG_HOME/netbeans"'

# nnn
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# node
export NODE_REPL_HISTORY="$HOME/.history/node_repl_history"

# npm / pnpm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_STORE_DIR="$XDG_DATA_HOME/pnpm-store"

# nvidia
#alias nvidia-settings='nvidia-settings --config $XDG_DATA_HOME/nvidia-settings'

# nvm
export NVM_DIR="$XDG_DATA_HOME"/nvm

# packer
export PACKER_CONFIG="$XDG_DATA_HOME/packer/packerconfig"
export PACKER_CONFIG_DIR="$XDG_DATA_HOME/packer/packer.d"

# pacman
alias pacman='pacman --color=auto'

# ping
alias ping='ping -c 5'

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# postgresql
export PSQLRC="$XDG_DATA_HOME/pg/psqlrc"
export PSQL_HISTORY="$HOME/.history/psql_history"
export PGPASSFILE="$XDG_DATA_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_DATA_HOME/pg/pg_service.conf"

# python
# https://github.com/python/cpython/pull/13208
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"

# qt
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] \
	|| export QT_QPA_PLATFORMTHEME="qt5ct"

# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# rm
alias rm='rm --preserve-root=all'

# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$CARGO_HOME/bin:$PATH"

# rvm
test -x "$HOME/.rvm/scripts/rvm" \
	&& . "$HOME/.rvm/scripts/rvm"
export PATH="$HOME/.rvm/bin:$PATH"

# sccache
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"
export SCCACHE_CACHE_SIZE="20G"

# screen
export SCREENRC="$XDG_CONFIG_HOME/screenrc"

# snap
#export PATH="/snap/bin:$PATH"
export PATH="/var/lib/snapd/snap/bin:$PATH"

# stack
export STACK_ROOT="$XDG_DATA_HOME/stack"

# subversion
export SUBVERSION_HOME="$XDG_CONFIG_HOME/subversion"

# sudo (sudo alises; see `info bash -n Aliases` for details)
alias sudo='sudo '

# task
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"

# terraform
export TF_CLI_CONFIG_FILE="$XDG_DATA_HOME/terraform/terraformrc-custom"

# tmux
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# vdir
alias vdir='vdir --color=auto'

# vagrant
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

# vim
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"

# wasmer
export WASMER_DIR="$XDG_DATA_HOME/wasmer"
# # shellcheck source=~/$XDG_DATA_HOME/wasmer/wasmer.sh
# test -x "$WASMER_DIR/wasmer.sh" && . "$WASMER_DIR/wasmer.sh"

# wasmtime
export WASMTIME_HOME="$XDG_DATA_HOME/wasmtime"
# export PATH="$WASMTIME_HOME/bin:$PATH"

# wget
alias wget='wget --config=$XDG_CONFIG_HOME/wget/wgetrc'

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

# X11
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XAUTHORITY="$XDG_DATA_HOME/X11/xauthority"

# yarn
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
export PATH="$XDG_DATA_HOME/yarn/global/node_modules/.bin:$PATH"

# yay
alias yay='yay --color=auto'

# zfs
export ZFS_COLOR=
