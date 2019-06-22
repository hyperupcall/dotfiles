#!/bin/bash

. init/remove-existing-dotfiles.sh
. init/xdg-user-dirs.sh

# stow
stow bash

# git
git config --global user.name "eankeen"
git config --global user.email "24364012+eankeen@users.noreply.github.com"
git config --global core.editor vim

