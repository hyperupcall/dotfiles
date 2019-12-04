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

# gnupg (git.gnupg.org/cgi-bin/gitweb.cgi)
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# poetry (github.com/sdispater/poetry)
export PATH="$HOME/.poetry/bin:$PATH"

# rust (github.com/rust-lang/rust)
export CARGO_HOME="$XDG_DATA_HOME/.cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/.rustup"

export PATH="$HOME/.local/share/.cargo/bin:$PATH"

# sccache (github.com/mozilla/sccache)
export SCCACHE_CACHE_SIZE="20G"
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"

# path
if test -d "$HOME/.local/bin"
then
    PATH="$HOME/.local/bin:$PATH"
fi

# misc
setfont /usr/share/kbd/consolefonts/ter-132n.psf.gz

