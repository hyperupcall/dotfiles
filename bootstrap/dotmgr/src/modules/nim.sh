# shellcheck shell=bash

if ! command -v 'choosenim' &>/dev/null; then
	print.info "Installing choosenim"
	util.req https://nim-lang.org/choosenim/init.sh | sh
fi

nimble install nimcr
