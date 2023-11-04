#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Setup Basalt?'; then
		setup.basalt
	fi
}

setup.basalt() {
	cargo install starship
	cargo install cargo-binstall
	cargo install fd-find
	cargo install modenv
	cargo install --locked bat
}

main "$@"
