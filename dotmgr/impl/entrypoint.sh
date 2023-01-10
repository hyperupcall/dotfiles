#!/usr/bin/env bash

die() {
	printf '%s\n' "$1" >&2
	exit 1
}

main() {
	if [ -z "$XDG_CONFIG_HOME" ]; then
		# shellcheck disable=SC2016
		die '$XDG_CONFIG_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_DATA_HOME" ]; then
		# shellcheck disable=SC2016
		die '$XDG_DATA_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_STATE_HOME" ]; then
		# shellcheck disable=SC2016
		die '$XDG_STATE_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	local file_to_exec="$1"
	local files_to_source_str="$2"

	local files_to_source=
	IFS=':' read -ra files_to_source <<< "$files_to_source_str"
	local file_to_source=
	for file_to_source in "${files_to_source[@]}"; do
		if [ -z "$file_to_source" ]; then continue; fi

		source "$file_to_source"
	done; unset -v file_to_source

	shift
	shift

	source "$file_to_exec"
	main "$@"
}

main "$@"
