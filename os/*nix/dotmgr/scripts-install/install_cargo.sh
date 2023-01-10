# shellcheck shell=bash

# Name:
# Install Cargo

main() {
	if util.confirm 'Install Rustup?'; then
		core.print_info "Installing rustup"
		util.req https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y || util.die

		rustup default nightly
	fi

	if util.confirm 'Install Rust packages?'; then
		cargo install starship
		cargo install cargo-binstall
		cargo install fd-find
		cargo install modenv
		cargo install --locked bat
	fi
}
