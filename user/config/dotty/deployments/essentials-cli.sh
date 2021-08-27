#!/usr/bin/env bash
set -ETeo pipefail

source ./util/core.sh

declare -a dotfiles=(
	"$home/.bashrc"
	"$home/.bash_logout"
	"$home/.bash_profile"
	"$home/.profile"
	"$cfg/aerc/aerc.conf"
	"$cfg/aerc/binds.conf"
	"$cfg/bash"
	"$cfg/bat"
	"$cfg/choose"
	"$cfg/cookiecutter"
	"$cfg/Code/User/keybindings.json"
	"$cfg/Code/User/settings.json"
	"$cfg/dircolors"
	"$cfg/dotty"
	"$cfg/environment.d"
	"$cfg/fish"
	"$cfg/gh/config.yml"
	"$cfg/git"
	"$cfg/glue"
	"$cfg/info"
	"$cfg/kak"
	"$cfg/nano"
	"$cfg/nvim"
	"$cfg/profile"
	"$cfg/readline"
	"$cfg/starship"
	"$cfg/vim"
	"$cfg/zsh"
)

for dotfile in "${dotfiles[@]}"; do
	printf "%s\n" "$dotfile"
done
