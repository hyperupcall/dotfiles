# shellcheck shell=bash

if ! command -v 'g' &>/dev/null; then
	print.info 'Installing g'
	util.req 'https://raw.githubusercontent.com/stefanmaric/g/next/bin/g' | sh -s
fi

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/godoc@latest

go get github.com/motemen/gore/cmd/gore
go get github.com/mdempsky/gocode
