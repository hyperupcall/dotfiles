#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Rustup?'; then
		core.print_info "Installing rustup"
		util.req https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y || util.die

		rustup default nightly
	fi

	if util.confirm 'Install Rust packages?'; then
		cargo install --locked starship
		cargo install --locked cargo-binstall
		cargo install --locked fd-find
		cargo install --locked modenv
		cargo install --locked bat
	fi
}

main "$@"
