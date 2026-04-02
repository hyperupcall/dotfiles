#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='bash-preexec'
declare -g g_dir="$HOME/.dotfiles/.data/repos/bash-preexec"

install.any() {
	util.clone "$g_dir" 'https://github.com/rcaloras/bash-preexec'
}

installed() {
	[ -d "$g_dir" ]
}

util.if_file_sourced || _setup "$@"
