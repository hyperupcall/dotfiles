# shellcheck shell=bash

if ! util.is_cmd rustup; then
	util.log_info "Installing rustup"
	util.req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
fi

rustup default nightly
