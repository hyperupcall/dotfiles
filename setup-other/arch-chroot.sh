#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='arch-chroot'
declare -g g_dir="$HOME/.dotfiles/.data/repos/arch-install-scripts"

install.any() {
	util.clone "$g_dir" https://github.com/archlinux/arch-install-scripts
	cd "$g_dir"

	make arch-chroot
	cp ./arch-chroot ~/.local/bin
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
