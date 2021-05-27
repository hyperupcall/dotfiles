# shellcheck shell=bash

# Utility functions specifically for the Bash environment

_bash_completion_debug() {
	echo
	echo "----- debug start -----"
	echo "#COMP_WORDS=${#COMP_WORDS[@]}"
	echo "COMP_WORDS=("
	for x in "${COMP_WORDS[@]}"; do
		echo "  '$x'"
	done
	echo ")"
	echo "COMP_CWORD=${COMP_CWORD}"
	echo "COMP_LINE='${COMP_LINE}'"
	echo "COMP_POINT=${COMP_POINT}"
	echo "cur: '${COMP_WORDS[COMP_CWORD]}'"
	echo "COMP_KEY=${COMP_KEY}"
	echo "COMP_TYPE=${COMP_TYPE}"
	echo "----- debug end -----"
}
