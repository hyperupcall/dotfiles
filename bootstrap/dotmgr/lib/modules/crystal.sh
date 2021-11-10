# shellcheck shell=bash

check_bin crystal

hash crystal &>/dev/null || {
	log_info "Installing crystal"
	req https://raw.github.com/pine/crenv/master/install.sh | bash
}
