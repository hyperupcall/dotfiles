#!/usr/bin/env bash

main() {
	cat <<-EOF
	# agnostic
	VAR_DOTMGR_DIR="$HOME/.dotfiles/os/*nix/dotmgr"

	# specific
	EOF

	#
	# desktop
	if [ "$(</sys/class/dmi/id/chassis_type)" = '3' ]; then
		cat <<-EOF
			VAR_PROFILE='desktop'
			VAR_REPOS_DIR="$HOME/repos"
		EOF
	#
	# laptop
	elif [ "$(</sys/class/dmi/id/chassis_type)" = '9' ]; then
		cat <<-EOF
			VAR_PROFILE='desktop'
			VAR_REPOS_DIR=$HOME/Documents
		EOF
	fi
}

main "$@"
