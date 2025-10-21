#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='arch-chroot'

main() {
	local dir="$HOME/.dotfiles/.data/repos/arch-install-scripts"
	util.clone "$dir" https://github.com/archlinux/arch-install-scripts

	cd "$dir"
	make arch-chroot
	cp ./arch-chroot ~/.local/bin
}

util.if_file_sourced || _setup "$@"
