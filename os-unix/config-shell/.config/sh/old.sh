# shellcheck shell=sh

## OTHER
# export BROWSER='brave-browser'
# export SPELL='aspell -x -c'

## XDG
# asdf
# export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
# ASDF_DIR="$XDG_DATA_HOME/asdf"
# export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
# _util_path_prepend "$ASDF_DIR/bin"
# _util_path_prepend "$ASDF_DATA_DIR/shims"

# atom
# export ATOM_HOME="$XDG_DATA_HOME/atom"

# bashmarks
# SDIRS="$XDG_DATA_HOME/bashmarks.sh.db"

# cookiecutter
# export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter/cookiecutterrc"

# cuda
# export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

# crenv
# export CRENV_ROOT="$XDG_DATA_HOME/crenv"
# _util_path_prepend "$CRENV_ROOT/bin"

# deno
# export DENO_INSTALL="$XDG_DATA_HOME/deno"
# _util_path_prepend "$DENO_INSTALL_ROOT"
# _util_path_prepend "$DENO_INSTALL_ROOT/bin"
# shellcheck shell=bash

# dvm
# export DVM_DIR="$XDG_DATA_HOME/dvm"
# _util_path_prepend "$DVM_DIR/bin"

# g
# export GOPATH="$XDG_DATA_HOME/gopath"
# export GOROOT="$XDG_DATA_HOME/goroot"
# _util_path_prepend "$GOPATH/bin"

# k9s
# export K9SCONFIG="$XDG_CONFIG_HOME/k9s"

# krew
# export KREW_ROOT="$XDG_STATE_HOME/krew"
# _util_path_prepend "$KREW_ROOT/bin"

# minikube
# export MINIKUBE_HOME="$XDG_STATE_HOME/minikube"

# n
# export N_PREFIX="$XDG_DATA_HOME/n"
# _util_path_prepend "$N_PREFIX/bin"

# nb
# export NBRC_PATH="$XDG_CONFIG_HOME/nb/nbrc"
# export NB_DIR="$XDG_DATA_HOME/nb"
# export NB_HIST="$XDG_STATE_HOME/history/nb_history"

# nimble
# _util_path_prepend "$XDG_DATA_HOME/nimble/bin"

# node-spawn-wrap
# export SPAWN_WRAP_SHIM_ROOT="$XDG_STATE_HOME/node-spawn-wrap"

# nvidia
# alias nvidia-settings='nvidia-settings --config $XDG_DATA_HOME/nvidia-settings'

# nvm
# export NVM_DIR="$XDG_DATA_HOME/nvm"

# opera
# export OPERA_PERSONALDIR="$XDG_STATE_HOME/opera"

# phpbrew
# _util_path_prepend "$XDG_DATA_HOME/phpenv/bin"

# plenv
# export PLENV_ROOT="$XDG_DATA_HOME/plenv"
# _util_path_prepend "$XDG_DATA_HOME/plenv/bin"

# phpenv
# export PHPENV_ROOT="$XDG_DATA_HOME/phpenv"
# _util_path_prepend "$PHPENV_ROOT/bin"

# pulse
# export PULSE_COOKIE="$XDG_STATE_HOME/pulse/cookie"

# pyenv
# export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
# export PYENV_VIRTUALENV_INIT=1
# _util_path_prepend "$PYENV_ROOT/bin"
# _util_path_prepend "$PYENV_ROOT/shims"

# pylint
# export PYLINTRC="$XDG_CONFIG_HOME/pylint/config"

# rbenv
# export RBENV_ROOT="$XDG_STATE_HOME/rbenv"
# _util_path_prepend "$RBENV_ROOT/bin"
# _util_path_prepend "$RBENV_ROOT/shims"

# rvm
# _util_path_prepend "$XDG_DATA_HOME/rvm/bin"

# sbt
# alias sbt='sbt -ivy "$XDG_DATA_HOME/ivy2" -sbt-dir "$XDG_DATA_HOME/sbt"'

# swift
# export SWIFTENV_ROOT="$XDG_DATA_HOME/swiftenv"
# _util_path_prepend "$SWIFTENV_ROOT/bin"

# todotxt
# export TODOTXT_CFG_FILE="$XDG_CONFIG_HOME/todotxt/config.sh"

# vimperator
# export VIMPERATOR_INIT=":source $XDG_CONFIG_HOME/vimperator/vimperatorrc"
# export VIMPERATOR_RUNTIME="$XDG_CONFIG_HOME/vimperator"

# volta
# export VOLTA_HOME="$XDG_STATE_HOME/volta"
# _util_path_prepend "$XDG_STATE_HOME/volta/bin"

# wakatime
# export WAKATIME_HOME="$XDG_DATA_HOME/wakatime"

# xsel
# mkdir -p "$XDG_DATA_HOME/xsel"
# alias xsel='xsel -l "$XDG_DATA_HOME/xsel/xsel.log'

# xsm
# export SM_SAVE_DIR="$XDG_DATA_HOME/xsm"

# X11
# export XCURSOR_PATH="$XDG_CONFIG_HOME/icons:$XCURSOR_PATH"
# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
# mkdir -p "$XDG_DATA_HOME/X11"
# export XCOMPOSEFILE="$XDG_CONFIG_HOME/X11/Xcompose"
# export XCOMPOSECACHE="$XDG_CACHE_HOME/X11/Xcompose"

### INITIALIZATION
# conda
# if [ -d "$XDG_DATA_HOME/miniconda3/bin" ]; then
# 	_util_path_prepend "$XDG_DATA_HOME/miniconda3/bin"
# 	eval "$(conda shell.bash hook)"
# fi

# gem
# _util_path_prepend "$HOME/.gem/ruby/2.7.0/bin"

# rbenv
# if command -v rbenv &>/dev/null; then
# 	eval "$(rbenv init - | while IFS= read -r line; do
# 		if [ "${line::11}" != 'export PATH' ]; then
# 			printf '%s\n' "$line"
# 		fi
# 	done )"
# fi

# sdkman
# if [ -n "$SDKMAN_DIR" ] && [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
# 	source "$SDKMAN_DIR/bin/sdkman-init.sh"
# fi
