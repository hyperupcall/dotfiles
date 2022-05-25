# shellcheck shell=bash

desktop.check() {
	# 9 is 'Desktop'
	if [ "$(</sys/class/dmi/id/chassis_type)" = '3' ]; then :; else
		return $?
	fi
}

desktop.vars() {
	REPO_DIR_REPLY="$HOME/repos"
}
