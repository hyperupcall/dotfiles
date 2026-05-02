#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='d'
declare -g g_dir="$HOME/.dotfiles/.data/repos/d"

install.any() {
	dependencies.debian() {
		sudo apt-get -y install bear
	}
	dependencies.ubuntu() {
		dependencies.debian "$@"
	}
	dependencies.fedora() {
		sudo dnf -y install bear
	}
	dependencies.opensuse() {
		sudo zypper -n install bear
	}
	dependencies.arch() {
		yay -Syu --noconfirm bear
	}

	util.install_by_setup --fn-prefix=dependencies --no-confirm --no-install-check "$@"

	util.clone "$g_dir" git@github.com:hyperupcall-projects/d
	cd "$g_dir"
	./bake build "$HOME/.dotfiles/data/dotfiles.c"
	ln -fs "$PWD/d" ~/.local/bin/d
	DEBUG= ~/.local/bin/d deploy
}

install.installed() {
	[ -d "$g_dir" ] && command -v d &>/dev/null
}

util.if_file_sourced || _setup "$@"
