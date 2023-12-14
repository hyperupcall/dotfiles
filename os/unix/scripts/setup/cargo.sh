#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Setup Cargo?'; then
		setup.basalt
	fi
}

setup.basalt() {
	cargo install --locked starship
	cargo install --locked cargo-binstall
	cargo install --locked fd-find
	cargo install --locked modenv
	cargo install --locked bat
}

main "$@"
