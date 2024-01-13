#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	util.install_and_configure 'basalt' 'Basalt' "$@"
}

install.basalt() {
	util.req -o- https://raw.githubusercontent.com/hyperupcall/basalt/main/scripts/install.sh | sh
}

configure.basalt() {
	basalt global add \
		hyperupcall/autoenv \
		hyperupcall/bake

	basalt global add \
		cykerway/complete-alias \
		rcaloras/bash-preexec \
		reconquest/shdoc
}

installed() {
	command -v basalt &>/dev/null

}
main "$@"
