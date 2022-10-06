# shellcheck shell=bash

# Name:
# Install Cargo

main() {
	if util.confirm 'Install Rustup?'; then
		source "$XDG_CONFIG_HOME/shell/modules/xdg.sh"

		if ! util.is_cmd 'rustup'; then
			core.print_info "Installing rustup"
			util.req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
			rustup default nightly
		fi
	fi

	if util.confirm 'Install Rust packages?'; then
		cargo install starship
		cargo install cargo-binstall
		cargo install fd-find
		cargo install modenv
		cargo install --locked bat
	fi
}
