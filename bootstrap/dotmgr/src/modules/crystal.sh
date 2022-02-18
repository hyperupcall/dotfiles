# shellcheck shell=bash

util.ensure_bin crystal

hash crystal &>/dev/null || {
	print.info "Installing crystal"
	util.req https://raw.github.com/pine/crenv/master/install.sh | bash
}
