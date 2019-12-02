#!/bin/sh

# general
export VISUAL=vim
export EDITOR="$VISUAL"

# xdg
export XDG_DATA_HOME="$HOME/.local/share" # default
export XDG_CONFIG_HOME="$HOME/.config" # default
export XDG_DATA_DIRS="/usr/local/share/:/usr/share" # default
export XDG_CONFIG_DIRS="/etc/xdg" # default
export XDG_CACHE_HOME="$HOME/.cache" # default
export XDG_RUNTIME_DIR="$HOME/.runtime"

# less
export LESSHISTFILE="$HOME/.config/lesshst"
export LESSHISTSIZE="250"

# gnupg
export GNUPGHOME="$HOME/.config/gnupg"

# vim
export VIMINIT="source "$HOME/.config/vim/vimrc""

# git
export GIT_CONFIG="$HOME/.config/gitconfig"

# npm
export NPM_CONFIG_USERCONFIG="$HOME/.config/npmrc/"

# n (https://github.com/tj/n)
export N_PREFIX="$HOME/.local/"

# yarn
export YARN_CACHE_FOLDER="$HOME/.cache/yarn"


