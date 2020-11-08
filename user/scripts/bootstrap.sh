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
git clone https://github.com/ohmyzsh/ohomyzsh "$XDG_DATA_HOME/oh-my-zsh"
git clone https://github.com/bash-it/bash-it "$XDG_DATA_HOME/bash-it"

curl -s "https://get.sdkman.io" | bash

( cd "$(mktemp -d)" && git clone https://github.com/charmbracelet/glow.git && cd glow && go build )
