#!/bin/sh

# general
export VISUAL=vim
export EDITOR="$VISUAL"

# custom
export CFG_DIR="$HOME/.cfg" # XDG_CONFIG_HOME can get quite bloated

# xdg
export XDG_DATA_HOME="$HOME/.local/share" # default
export XDG_CONFIG_HOME="$HOME/.config" # default
export XDG_DATA_DIRS="/usr/local/share/:/usr/share" # default
export XDG_CONFIG_DIRS="/etc/xdg" # default
export XDG_CACHE_HOME="$HOME/.cache" # default
#      XDG_RUNTIME_DIR

# less
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export LESSHISTSIZE="250"

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# vim (github.com/vim/vim)
# neovim (github.com/neovim/neovim)
export VIMINIT="source "$CFG_DIR/vim/vimrc""

# git (github.com/git/git) [mirror]
export GIT_CONFIG="$CFG_DIR/gitconfig"

# npm (github.com/npm/cli)
export NPM_CONFIG_USERCONFIG="$CFG_DIR/npmrc/"

# n (github.com/tj/n)
export N_PREFIX="$HOME/.local/"

# yarn (github.com/yarnpkg/yarn)
export YARN_CACHE_FOLDER="$HOME/.cache/yarn"

