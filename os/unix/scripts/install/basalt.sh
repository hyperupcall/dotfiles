#!/usr/bin/env bash

# Name:
# Install Basalt

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Basalt? packages'; then
		core.print_info 'Installing Basalt packages globally'

		basalt global add \
			hyperupcall/autoenv
		basalt global add \
			cykerway/complete-alias \
			rcaloras/bash-preexec \
			reconquest/shdoc
	fi
}

main "$@"
