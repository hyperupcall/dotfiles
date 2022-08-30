# shellcheck shell=bash

if util.confirm 'Install GHC?'; then
	core.print_info "Not implemented" # TODO (fully automate)
	# if ! command -v haskell >/dev/null 2>&1; then
	# 	core.print_info "Installing haskell"

	# 	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/ghcup"
	# 	ln -s "${XDG_DATA_HOME:-$HOME/.local/share}"/{,ghcup/.}ghcup

	# 	util.req https://get-ghcup.haskell.org | sh

	# 	util.req https://get.haskellstack.org/ | sh
	# fi
	:
fi
