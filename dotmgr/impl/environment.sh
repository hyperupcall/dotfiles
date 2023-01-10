#!/usr/bin/env bash

main() {
	# desktop
	if [ "$(</sys/class/dmi/id/chassis_type)" = '3' ]; then
		cat <<-EOF
			VAR_PROFILE=desktop
			VAR_REPOS_DIR="$HOME/repos"
		EOF
		return
	fi

	# laptop
	if [ "$(</sys/class/dmi/id/chassis_type)" = '9' ]; then
		VAR_REPOS_DIR=$HOME/Documents

		cat <<-EOF
			VAR_PROFILE=desktop
			VAR_REPOS_DIR=$HOME/Documents
		EOF
		return
	fi

	# container
	# TODO

	# vm
	# TODO

	return 1
}

main "$@"
