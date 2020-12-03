#!/usr/bin/env bash

set -ou pipefail

## helper functions
showHelp() {
	cat <<-EOF
		Usage:
		    dot.sh [command]

		Commands:
		    bootstrap [stage]
		        Bootstraps dotfiles, optionally add a stage to skip some steps

		    reconcile
		        Reconciles state

		    info
		        Prints info

		Examples:
		    dot.sh bootstrap i_rust
	EOF
}

# bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"

req() {
    curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

show() {
    echo "INSTALLING: $@"
}


## bootstrap
do_bootstrap() {
	read -rp "Are you sure you want to bootstrap? (y/n) "
	[[ $REPLY =~ y ]] || {
		echo "Will not execute bootstrap. Exiting"
	}

	fn="${1:-""}"
	[ -n "$fn" ] && {
		"$fn"
		return
	}

	i_rust
}

bootstrap_done() {
	echo "Bootstrap done
	Checklist:
	  - Remove extraneous lines from your ~/.bashrc
	  - Compile at /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret"
}

i_rust() {
	show rustup
	req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
	cargo install broot
	cargo install just
	cargo install starship
	cargo install git-delta
	rustup default nightly

	i_node
}

# todo: remove prompt
i_node() {
	show n
	req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash
	npm i -g pnpm
	npm i -g yarn
	pnpm i -g diff-so-fancy
	pnpm i -g cliflix
	yarn config set prefix "$XDG_DATA_HOME/yarn"

	i_dvm
}

i_dvm() {
	req https://deno.land/x/dvm/install.sh | sh
	dvm install

	i_ruby
}

i_ruby() {
	show rvm
	req https://get.rvm.io | bash -s -- --path "$XDG_DATA_HOME/rvm"

	i_python
}

i_python() {
	show pyenv
	req https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
	
	# ensure installation: libffi-devel
	pyenv install 3.9.0
	pyenv global 3.9.0

	show poetry
	req https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

	i_nim
}

i_nim() {
	show choosenim
	req https://nim-lang.org/choosenim/init.sh -sSf | sh

	i_zsh
}

i_zsh() {
	show zsh
	git clone https://github.com/ohmyzsh/oh-my-zsh "$XDG_DATA_HOME/oh-my-zsh"

	i_sdkman
}

i_sdkman() {
	show sdkman
	curl -s "https://get.sdkman.io" | bash

	i_tmux
}

i_tmux() {
	show tpm
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"

	i_bash
}

i_bash() {
	show bash-it
	git clone https://github.com/bash-it/bash-it "$XDG_DATA_HOME/bash-it"
	source "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config

	i_go
}

# todo: remove prompt
i_go() {
	show g
	curl -sSL https://git.io/g-install | sh -s
	go get -v golang.org/x/tools/gopls

	i_php
}

i_php() {
	show phpenv
	req https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \
		| PHPENV_ROOT=$HOME/data/phpenv bash

	i_perl
}

# todo: remove prompt (on unconfigured systems)
i_perl() {
	# https://github.com/regnarg/urxvt-config-reload
	cpan AnyEvent Linux::FD common::sense

	bootstrap_done
}

## ensure
do_ensure() {
	# ensure packages
	# pkg-config, libssl-dev starship

	type apt >/dev/null 2>&1 && {
		sudo apt install -y libssl-dev
		sudo apt install -y make gcc clang scrot xclip maim pkg-config libssl-dev trash-cli
	}

	type zypper >/dev/null 2>&1 && {
		# zip required by sdkman
		sudo zypper install -y openssl-devel zip
		sudo zypper install -y make clang scrot xclip maim pkg-config youtube-dl vlc cmus zsh restic rofi trash-cli exa bsdtar
	}

	# ensure commands
	# commands="make clang scrot xclip maim pkg-config"
	# commands2="youtube-dl vlc cmus git zsh glow restic"

	# for command in $commands $commands2; do
	# 	type "$command" >/dev/null 2>&1 || {
	# 		echo "Error: Command '$command' not installed. Install it"
	# 	}
	# done
}


## reconcile
do_reconcile() {
	# symlink
	ln -s ~/Docs/Programming/repos ~/repos ||:
	ln -s ~/Docs/Programming/projects ~/projects ||:
	ln -s ~/Docs/Programming/workspaces ~/workspaces ||:
	mkdir ~/.history ||:

	usermod -aG docker -aG libvirt -aG vboxusers edwin

	# remove files
	removeFiles=".lesshst .nv .dbshell .bash_history .yarn.lock node_modules .sonarlint .m2 Desktop Downloads Videos Documents Music Pictures"

	for file in $removeFiles; do
		# skip if doesn't already exist
		[ -e "$file" ] || return

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

	# create files
	createFolders="data/go-path $HOME/data/X11"
	for file in $createFolders; do
		mkdir "$file"
	done
}


## info
do_info() {
	lstopo
}


## start
[[ $@ =~ (--help) ]] && {
	showHelp
	exit 0
}

case "${1:-''}" in
bootstrap)
	shift
	do_bootstrap "$@"
	;;
ensure)
	shift
	do_ensure "$@"
	;;
reconcile)
	shift
	do_reconcile "$@"
	;;
info)
	shift
	do_info "$@"
	;;
*)
	echo "Error: No matching subcommand found" >&2
	showHelp >&2
	exit 1
	;;
esac
