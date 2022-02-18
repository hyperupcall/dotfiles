# shellcheck shell=bash

util.ensure_bin haskell
util.ensure_bin ghcup
util.ensure_bin stack

command -v haskell >/dev/null 2>&1 || {
	print.info "Installing haskell"

	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/ghcup"
	ln -s "${XDG_DATA_HOME:-$HOME/.local/share}"/{,ghcup/.}ghcup

	util.req https://get-ghcup.haskell.org | sh

	util.req https://get.haskellstack.org/ | sh
}
