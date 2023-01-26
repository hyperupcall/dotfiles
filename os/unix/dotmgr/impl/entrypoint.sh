#!/usr/bin/env bash

_die() {
	printf '%s: %s\n' "${0##*/}" "$1" >&2
	exit 1
}

# shellcheck disable=SC2016,SC2181
_main() {
	local file_to_exec="$1"
	local files_to_source_str="$2"
	shift || _die 'Failed to shift'
	shift || _die 'Failed to shift'

	# Source vendor
	local globstar_set='no'
	shopt -q globstar && globstar_set='yes'
	shopt -s globstar
	local f=
	for f in \
		"${0%/*}/../../vendor/bash-core/pkg"/**/*.sh \
		"${0%/*}/../../vendor/bash-term/pkg"/**/*.sh; do
		source "$f"
	done; unset -v f
	[ "$globstar_set" = 'no' ] && shopt -u globstar

	# Source utils
	local files=
	IFS=':' read -ra files <<< "$files_to_source_str"
	local f=
	for f in "${files[@]}"; do
		source "$f"
	done; unset -v f

	# Assert environment
	[ -z "$XDG_CONFIG_HOME" ] && _die 'Failed because $XDG_CONFIG_HOME is empty'
	[ -z "$XDG_DATA_HOME" ] && _die 'Failed because $XDG_DATA_HOME is empty'
	[ -z "$XDG_STATE_HOME" ] && _die 'Failed because $XDG_STATE_HOME is empty'

	# Run
	source "$file_to_exec"
}

_main "$@"
