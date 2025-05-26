#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='arch-chroot'

main() {
	helper.setup "$@"
}

install.any() {
	local dir="$HOME/.dotfiles/.data/repos/arch-install-scripts"
	util.clone "$dir" https://github.com/archlinux/arch-install-scripts

	cd "$dir"
	make arch-chroot
	cp ./arch-chroot ~/.local/bin
}

util.if_file_sourced || _main "$@"
