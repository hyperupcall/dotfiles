# shellcheck shell=bash

# Frameworks
# antibody
util.req 'https://git.io/antibody' | sh -s -- -b ~/.dots/.usr/bin/

# antigen
util.req 'https://git.io/antigen' > ~/.dots/.usr/share/antigen.zsh

# oh-my-zsh
util.clone_in_dots 'https://github.com/ohmyzsh/oh-my-zsh'

# prezto
util.clone_in_dots 'https://github.com/sorin-ionescu/prezto'

# sheldon
uril.req 'https://rossmacarthur.github.io/install/crate.sh' | bash -s -- --repo 'rossmacarthur/sheldon' --to ~/.dots/.usr/bin

# zgen
util.clone_in_dots 'https://github.com/tarjoilija/zgen'

# zimfw
util.req 'https://raw.githubusercontent.com/zimfw/install/master/install.zsh' | zsh

# zinit
util.req 'https://git.io/zinit-install' | zsh

# zplug
util.req 'https://raw.githubusercontent.com/zplug/installer/master/installer.zsh' | zsh
