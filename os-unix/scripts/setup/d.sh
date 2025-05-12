#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='d'

main() {
	helper.setup "$@"
}

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

	helper.setup --fn-prefix=dependencies "$@"

	local dir="$HOME/.dotfiles/.data/repos/d"
	util.clone "$dir" git@github.com:fox-incubating/d
	cd ~/.dotfiles/.data/repos/d
	./bake build "\"$HOME/.dotfiles/os-unix/data\""
	ln -fs "$PWD/d" ~/.local/bin/d
	~/.local/bin/d compile
	~/.local/bin/d deploy
}

installed() {
	command -v d &>/dev/null
}

util.if_file_sourced || helper.run_main "$@"
