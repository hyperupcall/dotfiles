#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='lefthook'

install.any() {
	mise install lefthook@latest
	mise use -g lefthook@latest
}

install.installed() {
	command -v lefthook &>/dev/null || [ -d "$XDG_DATA_HOME/mise/installs/lefthook" ]
}

util.if_file_sourced || _setup "$@"
