# shellcheck shell=bash

# Name:
# Install Basalt

main() {
	if util.confirm 'Install Basalt?'; then
		core.print_info 'Installing Basalt packages globally'

		basalt global add \
			hyperupcall/choose \
			hyperupcall/autoenv \
			hyperupcall/dotshellextract \
			hyperupcall/dotshellgen
		basalt global add \
			cykerway/complete-alias \
			rcaloras/bash-preexec \
			reconquest/shdoc
	fi
}
