#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='zinit'
declare -g g_dir="$HOME/.dotfiles/.data/repos/zinit"

install.any() {
	util.clone "$g_dir" 'https://github.com/zdharma-continuum/zinit'
}

install.installed() {
	[ -d "$g_dir" ]
}

install.configure() {
	util.write_shellfile 'zinit' \
		--zsh "
			fpath=(/usr/share/zsh/functions \$fpath)
			autoload -Uz is-at-least
			ZINIT_HOME='$g_dir'
			source \"\$ZINIT_HOME/zinit.zsh\""
}

util.if_file_sourced || _setup "$@"
