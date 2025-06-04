#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Rust'

main() {
	core.print_info "Installing rustup"
	curl -K "$CURL_CONFIG" https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y

	rustup default nightly

	cargo install --locked starship
	cargo install --locked cargo-binstall
	cargo install --locked fd-find
	cargo install --locked modenv
	cargo install --locked bat
}

installed() {
	command -v rustup &>/dev/null
}

util.if_file_sourced || _setup "$@"
