#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Go'

install.any() {
	mise install go@latest
	mise use -g go@latest

	go install golang.org/x/tools/gopls@latest
	go install golang.org/x/tools/cmd/godoc@latest
	go install golang.org/x/tools/cmd/goimports@latest

	go install github.com/x-motemen/gore/cmd/gore@latest
}

installed() {
	command -v go &>/dev/null
}

util.if_file_sourced || _setup "$@"
