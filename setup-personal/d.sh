#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='d'

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

	# TODO: g_dir
	local dir="$HOME/.dotfiles/.data/repos/d"
	util.clone "$dir" git@github.com:fox-incubating/d # TODO: names
	cd ~/.dotfiles/.data/repos/d
	./bake build "$HOME/.dotfiles/data/dotfiles.c"
	ln -fs "$PWD/d" ~/.local/bin/d
	DEBUG= ~/.local/bin/d deploy
}

installed() {
	command -v d &>/dev/null
}

util.if_file_sourced || _setup "$@"
