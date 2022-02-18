# shellcheck shell=bash

util.ensure_bin nim
util.ensure_bin nimble
util.ensure_bin nimcr

if ! command -v 'choosenim' &>/dev/null; then
	print.info "Installing choosenim"
	util.req https://nim-lang.org/choosenim/init.sh | sh
fi

nimble install nimcr
