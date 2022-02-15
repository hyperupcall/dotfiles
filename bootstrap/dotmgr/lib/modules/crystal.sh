# shellcheck shell=bash

util.ensure_bin crystal

hash crystal &>/dev/null || {
	util.log_info "Installing crystal"
	util.req https://raw.github.com/pine/crenv/master/install.sh | bash
}
