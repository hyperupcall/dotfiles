# shellcheck shell=bash

check_bin nim
check_bin nimble
check_bin nimcr

hash choosenim &>/dev/null || {
	log_info "Installing choosenim"
	req https://nim-lang.org/choosenim/init.sh | sh
}

nimble install nimcr
