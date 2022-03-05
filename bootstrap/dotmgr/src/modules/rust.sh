# shellcheck shell=bash

if ! util.is_cmd 'rustup'; then
	print.info "Installing rustup"
	util.req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
	rustup default nightly
fi
