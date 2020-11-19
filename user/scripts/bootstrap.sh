#!/usr/bin/env bash

set -euo pipefail

${XDG_DATA_HOME:="$HOME/.local/share"}

req() {
    curl --proto '=https' --tlsv1.2 -sSL "$@"
}

read -rp rustup
req https://sh.rustup.rs | sh

read -rp n
req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash

read -rp rvm
req https://get.rvm.io | bash -s -- --path "$XDG_DATA_HOME/rvm"

read -rp pyenv
req https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

read -rp choosenim
req https://nim-lang.org/choosenim/init.sh -sSf | sh

read -rp tpm
git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"

read -rp zsh
git clone https://github.com/ohmyzsh/ohomyzsh "$XDG_DATA_HOME/oh-my-zsh"

git clone https://github.com/bash-it/bash-it "$XDG_DATA_HOME/bash-it"
# ~/data/bash-it/install.sh
. "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config

curl -s "https://get.sdkman.io" | bash

bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)


#curl -sSL https://git.io/g-install | sh -s

curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \
    | PHPENV_ROOT=$HOME/data/phpenv bash

( cd "$(mktemp -d)" && git clone https://github.com/charmbracelet/glow.git && cd glow && go build )
