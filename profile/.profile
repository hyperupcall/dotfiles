#!/bin/sh

# general
export VISUAL="nvim"
export EDITOR="$VISUAL"
export PAGER="less"
export SUDO_EDITOR="nvim"

# xdg
export XDG_DATA_HOME="$HOME/.local/share" # default
export XDG_CONFIG_HOME="$HOME/.config" # defualt
export XDG_DATA_DIRS="/usr/local/share/:/usr/share" # default
export XDG_CONFIG_DIRS="/etc/xdg" # default
export XDG_CACHE_HOME="$HOME/.cache" # default

# npm (github.com/npm/cli)
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"

# n (github.com/tj/n)
export N_PREFIX="$HOME/.local/opt/n"
export PATH="$N_PREFIX/bin:$PATH"

# yarn (github.com/yarnpkg/yarn)
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
export PATH="$XDG_DATA_HOME/yarn/global/node_modules/.bin:$PATH"

# less
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export LESSHISTSIZE="250"

# gnupg (git.gnupg.org/cgi-bin/gitweb.cgi)
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GPG_TTY=$(tty)

# poetry (github.com/sdispater/poetry)
export PATH="$HOME/.poetry/bin:$PATH"

# rust (github.com/rust-lang/rust)
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$HOME/.local/share/cargo/bin:$PATH"

# sccache (github.com/mozilla/sccache)
export SCCACHE_CACHE_SIZE="20G"
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"

# snap
export PATH="/snap/bin:$PATH"

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$HOME/.local/share/mathematica"

# terraform (github.com/hashicorp/terraform)
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraformrc-custom"

# nnn (github.com/jarun/nnn)
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# go (github.com/golang/go)
export GOROOT="$HOME/.local/go-root"
export GOPATH="$HOME/.local/go-path"
export PATH="$HOME/.local/go-path/bin:$PATH"

# krew (github.com/kubernetes-sigs/krew
export KREW_ROOT="$HOME/.local/opt/krew"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# flutter (github.com/flutter/flutter)
export PATH="$HOME/.local/opt/flutter/bin:$PATH"

# android
export ANDROID_SDK_ROOT="$HOME/.local/opt/android/sdk"

# buku (github.com/jarun/buku)
alias b='buku --suggest'

# google cloud sdk
if [ -f "$HOME/.local/google-cloud-sdk/path.bash.inc" ]; then . "$HOME/.local/google-cloud-sdk/path.bash.inc"; fi
if [ -f "$HOME/.local/google-cloud-sdk/completion.bash.inc" ]; then . "$HOME/.local/google-cloud-sdk/completion.bash.inc"; fi

# path
export PATH="$HOME/.local/bin:$PATH"

