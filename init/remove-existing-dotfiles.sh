#!/bin/bash

# gnu stow does not remove preexisting files
# this script removes files that could cause clashes

echo "removing existing dotfiles"

# remove the dotfile
remove-existing-dotfile() {
  # test -f "$1" && echo rm "$1" || echo "skipping ${1}"
  if test -f "$1"
  then
    echo "removing ${1}"
    rm "$1"
  fi
}

declare -a files=(
  ~/.bashrc
  ~/.profile
  ~/.vimrc
)

for file in "${files[@]}"; do
  remove-existing-dotfile "$file"
done

echo "done removing existing dotfiles"
