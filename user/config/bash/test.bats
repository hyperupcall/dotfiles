#!/usr/bin/env bats

set -o vi
source bashrc.sh

@test "_readline_util_get_cmd normal" {
	local result

	READLINE_LINE='ls'
	result="$(_readline_util_get_cmd)"

	[[ $result == 'ls' ]]
}

@test "_readline_util_get_cmd normal with space" {
	local result

	READLINE_LINE=' ls'
	result="$(_readline_util_get_cmd)"

	[[ $result == 'ls' ]]
}

@test "_readline_util_get_cmd sudo" {
	local result

	READLINE_LINE='sudo ls'
	result="$(_readline_util_get_cmd)"

	[[ $result == 'ls' ]]
}

@test "_readline_util_get_cmd sudo with space" {
	local result

	READLINE_LINE=' sudo  ls'
	result="$(_readline_util_get_cmd)"

	[[ $result == 'ls' ]]
}

@test "_readline_util_get_cmd with quotes" {
	local result

	# '
	READLINE_LINE="'ls'"
	result="$(_readline_util_get_cmd)"

	[[ $result == 'ls' ]]

	# "
	READLINE_LINE='"ls"'
	result="$(_readline_util_get_cmd)"

	[[ $result == 'ls' ]]
}

@test "_readline_util_get_cmd with prefixed backslash" {
	local result

	READLINE_LINE='\ls'
	result="$(_readline_util_get_cmd)"
	[[ $result == 'ls' ]]
}
