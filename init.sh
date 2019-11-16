#!/bin/sh

. init/remove-existing-dotfiles.sh
. init/xdg-user-dirs.sh

# stow
stow -S bash
stow -S git
stow -S vscode
stow -S vim
