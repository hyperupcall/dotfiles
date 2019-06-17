#!/bin/bash

. init/remove-existing-dotfiles.sh
. init/xdg-user-dirs.sh

# stow
stow bash

# git
git config user.name "eankeen"
git config user.email "24364012+eankeen@users.noreply.github.com"
git config core.editor vim
