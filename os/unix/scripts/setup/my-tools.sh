#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Setup my tools?'; then
		setup.tools
	fi
}

setup.tools() {
	cargo install \
		fox-template \
		fox-dotfile \
		fox-repo \
		fox-repos \
		fox-default
}

main "$@"
