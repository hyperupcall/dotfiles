# shellcheck shell=sh

# deno
# export DENO_INSTALL="$XDG_DATA_HOME/deno"
# export DENO_INSTALL_ROOT="$DENO_INSTALL/bin"
# _path_prepend "$DENO_INSTALL_ROOT"
# _path_prepend "$DENO_INSTALL_ROOT/bin"
# shellcheck shell=bash

# g
export GOPATH="$XDG_DATA_HOME/gopath"
export GOROOT="$XDG_DATA_HOME/goroot"
_path_prepend "$GOPATH/bin"
