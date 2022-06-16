# shellcheck shell=bash

laptop.check() {
	# 9 is 'Laptop'
	if [ "$(</sys/class/dmi/id/chassis_type)" = '9' ]; then :; else
		return $?
	fi
}

laptop.vars() {
	REPO_DIR_REPLY="$HOME/Documents"
}
