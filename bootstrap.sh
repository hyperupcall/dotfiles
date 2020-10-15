#!/usr/bin/env bash

set -euo pipefail

${XDG_DATA_HOME:="$HOME/.local/share"}

req() {
    cul --proto '=https' --tlsv1.2 -sSL "$@"
}

read -p rustup
req https://sh.rustup.rs | sh

read -p n
req https://git.io/n-install | bash

read -p rvm
curl -sSL https://get.rvm.io | bash -s -- --path "$XDG_DATA_HOME/rvm"

read -p pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash