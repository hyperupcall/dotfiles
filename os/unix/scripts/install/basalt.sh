#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Basalt packages?'; then
		install.basalt
	fi
}

install.basalt() {
	basalt global add \
		hyperupcall/autoenv

	basalt global add \
		cykerway/complete-alias \
		rcaloras/bash-preexec \
		reconquest/shdoc
}

main "$@"
