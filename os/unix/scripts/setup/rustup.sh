#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Rustup?'; then
		install.rustup
	fi
}

install.rustup() {
	util.req https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y || util.die

	rustup default nightly
}

main "$@"
