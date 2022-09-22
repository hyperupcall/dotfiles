# shellcheck shell=sh

# asdf
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="$XDG_CONFIG_HOME/asdf/tool-versions"
_path_prepend "$ASDF_DIR/bin"
_path_prepend "$ASDF_DATA_DIR/shims"

# atom
# export ATOM_HOME="$XDG_DATA_HOME/atom"

# crenv
# export CRENV_ROOT="$XDG_DATA_HOME/crenv"
# _path_prepend "$CRENV_ROOT/bin"

# deno
# export DENO_INSTALL="$XDG_DATA_HOME/deno"
# _path_prepend "$DENO_INSTALL_ROOT"
# _path_prepend "$DENO_INSTALL_ROOT/bin"
# shellcheck shell=bash

# g
# export GOPATH="$XDG_DATA_HOME/gopath"
# export GOROOT="$XDG_DATA_HOME/goroot"
# _path_prepend "$GOPATH/bin"

# k9s
# export K9SCONFIG="$XDG_CONFIG_HOME/k9s"
