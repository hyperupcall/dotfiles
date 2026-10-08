#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='arch-chroot'
declare -g g_dir="$HOME/.dotfiles/.data/repos/arch-install-scripts"

install.any() {
	util.clone "$g_dir" https://github.com/archlinux/arch-install-scripts
	cd "$g_dir"

	sudo apt-get -y install m4 # TODO
	make arch-chroot
	cp ./arch-chroot ~/.local/bin
}

install.installed() {
	[ -d "$g_dir" ] && command -v arch-chroot &>/dev/null
}

util.if_file_sourced || _setup "$@"
