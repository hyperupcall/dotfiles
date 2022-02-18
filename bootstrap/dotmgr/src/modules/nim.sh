# shellcheck shell=bash

util.ensure_bin nim
util.ensure_bin nimble
util.ensure_bin nimcr

hash choosenim &>/dev/null || {
	print.info "Installing choosenim"
	util.req https://nim-lang.org/choosenim/init.sh | sh
}

nimble install nimcr
