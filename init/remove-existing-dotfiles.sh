#!/bin/bash

# gnu stow does not remove preexisting files
# this script removes files that could cause clashes

remove-existing-dotfile() {
  if [[ -e $1 && ! -h $1 ]]
  then
    rm $1
  fi
}

declare -a files=("~/.bashrc" "~/.profile")

for file in ${files[@]}; do
  remove-existing-dotfile $file
done

