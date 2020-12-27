# shellcheck shell=sh

# anki
alias anki='anki -b "$XDG_DATA_HOME/anki"'

# atom
export ATOM_HOME="$XDG_DATA_HOME/atom"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_DATA_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_DATA_HOME/aws/config"

# boto
export BOTO_CONFIG="$XDG_DATA_HOME/boto"

# bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
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
alias dd='dd status=progress'

# deno
export DENO_INSTALL="$XDG_DATA_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_INSTALL/bin"
path_add_pre "$DENO_INSTALL_ROOT"
path_add_pre "$DENO_INSTALL_ROOT/bin"

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
alias dotty='dotty --dotfiles-dir=$HOME/.dots'

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
path_add_pre "$GOPATH/bin"

# gem
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

# gitlib
export GITLIBS="$XDG_DATA_HOME/gitlibs"

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
GPG_TTY="$(tty)"
export GPG_TTY

# grep
alias grep='grep --colour=auto'

# git
export GIT_CONFIG_NOSYSTEM=

# gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# gtk
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# gvm
# TODO: fix
export GVM_ROOT="$XDG_DATA_HOME/gvm"
export GVM_DEST="$GVM_ROOT"
test -x "$GVM_ROOT/scripts/gvm-default" && . "$GVM_ROOT/scripts/gvm-default"

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
export JUNEST_HOME="$XDG_DATA_HOME/junest"

# jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# kde
export KDEHOME="$XDG_CONFIG_HOME/kde"

# krew
export KREW_ROOT="$XDG_DATA_HOME/krew"
path_add_pre "$KREW_ROOT/bin"

# kubernetes
export KUBECONFIG="$XDG_DATA_HOME/kube"

# less
# adding X breaks mouse scrolling of pages
export LESS="-FIRQ"
# export LESS="-FIRX" LESS="-M -I -R"
export LESSKEY="$XDG_CONFIG_HOME/less_keys"
export LESSHISTFILE="$HOME/.history/less_history"
export LESSHISTSIZE="32768"
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

# ls
alias ls='ls --color=auto -h'

# ltrace
alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

# maven
alias mvn='mvn -gs "$XDG_CONFIG_HOME/maven/settings.xml"'
mkdir -p "$XDG_DATA_HOME/maven"

# mongo
alias mongo='mongo --norc'

# more
export MORE="-l"

# most
export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

# mplayer
export MPLAYER_HOME="$XDG_DATA_HOME/mplayer"

# mysql
export MYSQL_HISTFILE="$HOME/.history/mysql_history"

# n
export N_PREFIX="$XDG_DATA_HOME/n"
path_add_pre "$N_PREFIX/bin"

# nb
export NB_DIR="$XDG_DATA_HOME/nb"
export NB_HIST="$HOME/.history/nb_history"

# netbeams
# alias netbeams='netbeans --userdir "$XDG_CONFIG_HOME/netbeans"'

# nimble
export CHOOSENIM_NO_ANALYTICS="1"
#alias nimble='nimble --choosenimDir="$XDG_DATA_HOME/choosenim"'
path_add_pre "$HOME/.nimble/bin"
path_add_pre "$XDG_DATA_HOME/nimble/bin"

# nnn
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# node
export NODE_REPL_HISTORY="$HOME/.history/node_repl_history"
export TS_NODE_HISTORY="$HOME/.history/ts_node_repl_history"

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
export CHECKPOINT_DISABLE=1

# pacman
alias pacman='pacman --color=auto'

# phpbrew
path_add_pre "$XDG_DATA_HOME/phpenv/bin"

# phpenv
export PHPENV_ROOT="$XDG_DATA_HOME/phpenv"
path_add_pre  "$PHPENV_ROOT/bin"

# poetry
export POETRY_HOME="$XDG_DATA_HOME/poetry"
path_add_pre "$POETRY_HOME/bin"

# postgresql
export PSQLRC="$XDG_DATA_HOME/pg/psqlrc"
export PSQL_HISTORY="$HOME/.history/psql_history"
export PGPASSFILE="$XDG_DATA_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_DATA_HOME/pg/pg_service.conf"

# pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
path_add_pre "$PYENV_ROOT/bin"
path_add_pre "$PYENV_ROOT/shims"

# python
# https://github.com/python/cpython/pull/13208
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"

# qt
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] \
	|| export QT_QPA_PLATFORMTHEME="qt5ct"

# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
path_add_pre "$CARGO_HOME/bin"

# rvm
# todo: bashisms
path_add_pre "$XDG_DATA_HOME/rvm/bin"
path_add_pre "$XDG_DATA_HOME/gem/bin"
[ -x "$XDG_DATA_HOME/rvm/scripts/rvm" ] && . "$XDG_DATA_HOME/rvm/scripts/rvm"

# sccache
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"

# screen
export SCREENRC="$XDG_CONFIG_HOME/screenrc"

# sdkman
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
[ -x "$SDKMAN_DIR/bin/sdkman-init.sh" ] && . "$SDKMAN_DIR/bin/sdkman-init.sh"

# sonarlint
export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint"

# stack
export STACK_ROOT="$XDG_DATA_HOME/stack"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# subversion
export SUBVERSION_HOME="$XDG_CONFIG_HOME/subversion"

# task
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"

# texmf
export TEXMFHOME="$XDG_DATA_HOME/textmf"

# todotxt
export TODOTXT_CFG_FILE="$XDG_CONFIG_HOME/todotxt/config.sh"

# tmux
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"


# vagrant
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

# vim
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"

# wakatime
export WAKATIME_HOME="$XDG_DATA_HOME/wakatime"

# wasmer
export WASMER_DIR="$XDG_DATA_HOME/wasmer"
# # shellcheck source=~/$XDG_DATA_HOME/wasmer/wasmer.sh
# test -x "$WASMER_DIR/wasmer.sh" && . "$WASMER_DIR/wasmer.sh"

# wasmtime
export WASMTIME_HOME="$XDG_DATA_HOME/wasmtime"
path_add_pre "$WASMTIME_HOME/bin"

# wget
#WGETRC=
alias wget='wget --config=$XDG_CONFIG_HOME/wget/wgetrc'

# wine
export WINEPREFIX="$XDG_DATA_HOME/wine"

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

<<<<<<< HEAD
# x11
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

=======
>>>>>>> 8c4ef90 (update dotfiles)
# yarn
path_add_pre "$XDG_DATA_HOME/yarn/bin"
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"

# yay
alias yay='yay --color=auto'

# z
export _Z_DATA="$XDG_DATA_HOME/z"

# zfs
export ZFS_COLOR=
