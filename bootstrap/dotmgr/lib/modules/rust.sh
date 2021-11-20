# shellcheck shell=bash

if ! command -v rustup &>/dev/null; then
	log_info "Installing rustup"
	req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
fi

rustup default nightly
