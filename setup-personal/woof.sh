#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Woof'
declare -g g_dir="$HOME/.dotfiles/.data/repos/woof"

install.any() {
	basalt global add version-manager/woof
}

install.source() {
	util.clone "$g_dir" 'https://github.com/version-manager/woof'
	cd "$g_dir"
	basalt install

	local prefix="$HOME/.local"
	mkdir -p "$prefix/bin"
	ln -sf "$PWD/pkg/bin/woof" "$prefix/bin/woof"
}

installed() {
	[ -L ~/.local/bin/woof ]
}

configure() {
	util.write_shellfile 'woof' \
		--bash 'eval "$(woof init --no-cd bash)"' \
		--zsh 'eval "$(woof init --no-cd zsh)"'
}

util.if_file_sourced || _setup "$@"
