#!/bin/sh

# general
export VISUAL=vim
export EDITOR="$VISUAL"

# xdg (defaults)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

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
