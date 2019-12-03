#!/bin/sh

# general
export VISUAL="vim"
export EDITOR="$VISUAL"

# custom
export CFGDIR="$HOME/.config"

# xdg
export XDG_DATA_HOME="$HOME/.local/share" # default
export XDG_CONFIG_HOME="$HOME/.config" # defualt
export XDG_DATA_DIRS="/usr/local/share/:/usr/share" # default
export XDG_CONFIG_DIRS="/etc/xdg" # default
export XDG_CACHE_HOME="$HOME/.cache" # default
#      XDG_RUNTIME_DIR # set by pam_systemd

# vim (github.com/vim/vim)
export VIMINIT="source "$CFGDIR/vim/vimrc""

# npm (github.com/npm/cli)
export NPM_CONFIG_USERCONFIG="$CFGDIR/npmrc"

# n (github.com/tj/n)
export N_PREFIX="$HOME/.local"

# yarn (github.com/yarnpkg/yarn)
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"

# less
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export LESSHISTSIZE="250"

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

