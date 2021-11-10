# shellcheck shell=bash

check_bin haskell
check_bin ghcup
check_bin stack

command -v haskell >/dev/null 2>&1 || {
	log_info "Installing haskell"

	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/ghcup"
	ln -s "${XDG_DATA_HOME:-$HOME/.local/share}"/{,ghcup/.}ghcup

	req https://get-ghcup.haskell.org | sh

	req https://get.haskellstack.org/ | sh
}
