#!/usr/bin/env bash

set -eou pipefail

#youtube-dl, vlc, cmus
# mkdir ~/data/X11

showHelp() {
	cat <<-EOF
		Usage:
		    dot [command]

		Commands:
		    bootstrap
		        Bootstraps dotfiles

		    reconcile
		        Reconciles state

		    info
		        Prints info
	EOF
}


# ----------------------- bootstrap ---------------------- #
req() {
    curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

show() {
    echo "INSTALLING: $@"
}

ensureDependencies() {
	# pkg-config, libssl-dev starship
	sudo apt install make gcc clang scrot xclip maim pkg-config libssl-dev
}

bootstrap() {
	read -rp "Are you sure you want to bootstrap? (y/n) "
	[[ $REPLY =~ y ]] || {
		echo "Will not execute bootstrap. Exiting"
	}

	# rust
	show rustup
	req https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y
	cargo install broot
	cargo install just
	cargo install starship
	cargo install git-delta

	# node
	show n
	req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash
	npm i -g pnpm
	npm i -g yarn
	pnpm i -g diff-so-fancy
	pnpm i -g cliflix
	yarn config set prefix "$XDG_DATA_HOME/yarn"

	# dvm
	req https://deno.land/x/dvm/install.sh | sh
	dvm install

	# ruby
	show rvm
	req https://get.rvm.io | bash -s -- --path "$XDG_DATA_HOME/rvm"

	# python
	show pyenv
	req https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

	# nim
	show choosenim
	req https://nim-lang.org/choosenim/init.sh -sSf | sh

	# tmux
	show tpm
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"

	# zsh
	show zsh
	git clone https://github.com/ohmyzsh/ohomyzsh "$XDG_DATA_HOME/oh-my-zsh"

	# bash
	show bash-it
	git clone https://github.com/bash-it/bash-it "$XDG_DATA_HOME/bash-it"
	source "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config

	# bash
	show sdkman
	curl -s "https://get.sdkman.io" | bash

	# gvm
	# bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

	# go
	show g
	curl -sSL https://git.io/g-install | sh -s

	# php
	show phpenv
	curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \
	| PHPENV_ROOT=$HOME/data/phpenv bash

	# misc
	show glow
	( \
		cd "$(mktemp -d)" \
		&& git clone https://github.com/charmbracelet/glow.git \
		&& cd glow \
		&& go install \
		)

	reconcile
}


# ----------------------- reconcile ---------------------- #
reconcile() {
	ensureDependencies

	ln -s ~/Docs/Programming/repos ~/repos
	ln -s ~/Docs/Programming/projects ~/projects
	ln -s ~/Docs/Programming/workspaces ~/workspaces

	removeFiles=".lesshst .nv .dbshell .bash_history .yarn.lock node_modules .sonarlint .m2 Desktop Downloads Videos Documents Music Pictures"

	for file in $removeFiles; do
		# skip if doesn't already exist
		[ -e "$file"] || return

		command -v trash-put >/dev/null 1>&2 && {
			trash-put "$file"
		}

		# folder
		[ -d "$file" ] && {

			return
		}

		# file
		rm "$file"
	done

	createFolders="data/go-path"

	for file in $createFolders; do
		mkdir "$file"
	done


	checkFiles=".swp"
}


# ------------------------- info ------------------------- #
info() {
	lstopo
}


# ------------------------- start ------------------------ #
[[ $@ =~ (--help) ]] && {
	showHelp
	exit 0
}

command="$1"
shift

case "$command" in
bootstrap)
	bootstrap "$@"
	;;
reconcile)
	reconcile "$@"
	;;
info)
	info "$@"
	;;
*)
	echo "Error: No matching command found"
	exit 1
	;;
esac
