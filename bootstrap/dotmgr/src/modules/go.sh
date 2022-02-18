# shellcheck shell=bash

util.ensure_bin go

# TODO: remove prompt
if ! command -v 'g' &>/dev/null; then
	print.info "Installing g"
	util.req https://git.io/g-install | sh -s
fi

go get -v golang.org/x/tools/gopls
go install golang.org/x/tools/cmd/godoc@latest
go install github.com/go-delve/delve/cmd/dlv@latest

go get github.com/motemen/gore/cmd/gore
go get github.com/mdempsky/gocode
