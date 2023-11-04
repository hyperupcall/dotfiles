#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Setup Basalt?'; then
		setup.basalt
	fi
}

setup.basalt() {
	basalt global add \
		hyperupcall/autoenv

	basalt global add \
		cykerway/complete-alias \
		rcaloras/bash-preexec \
		reconquest/shdoc
}

main "$@"
