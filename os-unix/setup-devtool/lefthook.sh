#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='lefthook'

main() {
	mise install lefthook@latest
	mise use -g lefthook@latest
}

installed() {
	command -v lefthook &>/dev/null || [ -d "$XDG_DATA_HOME/mise/installs/lefthook" ]
}

util.if_file_sourced || _setup "$@"
