# shellcheck shell=bash

util.ensure_bin crystal

if ! command -v 'crystal' &>/dev/null; then
	print.info "Installing crystal"
	util.req https://raw.github.com/pine/crenv/master/install.sh | bash
fi
