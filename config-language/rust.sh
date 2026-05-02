#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Rust'

install.any() {
	if [ ! -d "${CARGO_HOME:-"$HOME/.rustup"}" ]; then
		core.print_info "Installing rustup"
		curl -K "$CURL_CONFIG" https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y

		rustup default nightly
	fi

	cargo install --locked starship
	cargo install --locked cargo-binstall
	cargo install --locked fd-find
	cargo install --locked modenv
	cargo install --locked bat
}

install.installed() {
	command -v rustup help &>/dev/null && command -v cargo &>/dev/null && command -v rustc &>/dev/null && command -v bat &>/dev/null
}

install.configure() {
	util.write_shellfile 'rust' \
		--sh '. "${CARGO_HOME:-"$HOME/.cargo"}/env"' \
		--bash 'source "${CARGO_HOME:-"$HOME/.cargo"}/env"' \
		--zsh 'source "${CARGO_HOME:-"$HOME/.cargo"}/env"'
}

util.if_file_sourced || _setup "$@"
