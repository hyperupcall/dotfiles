# shellcheck shell=bash

check_bin nim
check_bin nimble
check_bin nimcr

hash choosenim &>/dev/null || {
	util.log_info "Installing choosenim"
	util.req https://nim-lang.org/choosenim/init.sh | sh
}

nimble install nimcr
