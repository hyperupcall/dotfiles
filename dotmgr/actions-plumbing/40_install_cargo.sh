# shellcheck shell=bash

# Name:
# Install Cargo

main() {
	if util.confirm 'Install Rustup?'; then
		if ! util.is_cmd 'rustup'; then
			core.print_info "Installing rustup"
			util.req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
			rustup default nightly
		fi
	fi
	cargo install starship
}
