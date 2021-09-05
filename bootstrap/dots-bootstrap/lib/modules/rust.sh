# shellcheck shell=bash

# TODO: while we could check here and install
# as rust crates directly, should really move
# this somewhere else relating to the applications
# more
check_bin broot
check_bin starship
check_bin git-delta
check_bin navi

hash rustup &>/dev/null || {
	log_info "Installing rustup"
	req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
}

rustup default nightly
