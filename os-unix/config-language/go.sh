#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

declare -g g_name='Go'

main() {
	mise install go@latest
	mise use -g go@latest

	go install golang.org/x/tools/gopls@latest
	go install golang.org/x/tools/cmd/godoc@latest
	go install golang.org/x/tools/cmd/goimports@latest

	go install github.com/x-motemen/gore/cmd/gore@latest
}

util.if_file_sourced || _setup "$@"
