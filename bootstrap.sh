#!/usr/bin/env bash

set -euo pipefail

${XDG_DATA_HOME:="$HOME/.local/share"}

req() {
    curl --proto '=https' --tlsv1.2 -sSL "$@"
}

read -p rustup
req https://sh.rustup.rs | sh

read -p n
req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash

read -p rvm
req https://get.rvm.io | bash -s -- --path "$XDG_DATA_HOME/rvm"

read -p pyenv
req https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

read -p choosenim
req https://nim-lang.org/choosenim/init.sh -sSf | sh

git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"
