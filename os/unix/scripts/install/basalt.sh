#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Basalt?'; then
		install.basalt
	fi
}

install.basalt() {
	util.req -o- https://raw.githubusercontent.com/hyperupcall/basalt/main/scripts/install.sh | sh
}

main "$@"
