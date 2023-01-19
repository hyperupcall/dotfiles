#!/usr/bin/env bash

_die() {
	printf '%s: %s\n' "${0##*/}" "$1" >&2
	exit 1
}

# shellcheck disable=SC2016,SC2181
_main() {
	local file_to_exec="$1"
	local files_to_source_str="$2"
	shift || _die 'Failed shift'
	shift || _die 'Failed shift'

	local files=
	IFS=':' read -ra files <<< "$files_to_source_str"
	local f=
	for f in "${files[@]}"; do
		source "$f"
	done; unset -v f

	[ -z "$XDG_CONFIG_HOME" ] && _die 'Failed because $XDG_CONFIG_HOME is empty'
	[ -z "$XDG_DATA_HOME" ] && _die 'Failed because $XDG_DATA_HOME is empty'
	[ -z "$XDG_STATE_HOME" ] && _die 'Failed because $XDG_STATE_HOME is empty'

	source "$file_to_exec"
}

_main "$@"
