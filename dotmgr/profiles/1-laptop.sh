# shellcheck shell=bash

profile.check() {
	# 9 is 'Laptop'
	if [ "$(</sys/class/dmi/id/chassis_type)" = '9' ]; then :; else
		return $?
	fi
}

profile.vars() {
	VAR_REPOS_DIR="$HOME/Documents"
}
