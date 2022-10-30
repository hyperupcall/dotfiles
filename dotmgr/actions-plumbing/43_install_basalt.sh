# shellcheck shell=bash

# Name:
# Install Basalt

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
