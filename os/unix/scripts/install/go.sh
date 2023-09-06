#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Go packages?'; then
		go install golang.org/x/tools/gopls@latest
		go install golang.org/x/tools/cmd/godoc@latest

		go install github.com/motemen/gore/cmd/gore@latest
		go install github.com/mdempsky/gocode@latest
	fi
}

main "$@"
