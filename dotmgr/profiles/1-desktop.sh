# shellcheck shell=bash

profile.check() {
	# 3 is 'Desktop'
	if [ "$(</sys/class/dmi/id/chassis_type)" = '3' ]; then :; else
		return $?
	fi
}

profile.vars() {
	VAR_REPOS_DIR="$HOME/repos"
}
