# shellcheck shell=bash
# TODO: still have thing show up with no comment

# Name:
# SSSS
#
# Description:
# Executes dotfox with the right arguments. The command is shown before it is ran
# Before executing, however, it removes ~/.config/user-dirs.dirs

main() {
	echo 'first'

	dotmgr.get_profile
	printf '%s\n' "profile: $REPLY"

	dotmgr.call 'other'
}
