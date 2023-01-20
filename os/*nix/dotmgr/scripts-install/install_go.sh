# shellcheck shell=bash

{
	if util.confirm 'Install Go packages?'; then
		go install golang.org/x/tools/gopls@latest
		go install golang.org/x/tools/cmd/godoc@latest

		go get github.com/motemen/gore/cmd/gore
		go get github.com/mdempsky/gocode
	fi
}