#!/usr/bin/env bats

load ../../../vendor/bats-all/load.bash
load ./util.sh

@test "_util_path_append separates entries and preserves spaces" {
	local path_entries='/first path:/second'
	_util_path_append path_entries '/third path'
	assert_equal "$path_entries" '/first path:/second:/third path'
}

@test "_util_path_append initializes empty and unset variables" {
	local path_entries=''
	_util_path_append path_entries '/first'
	assert_equal "$path_entries" '/first'

	unset path_entries
	_util_path_append path_entries '/second'
	assert_equal "$path_entries" '/second'
}

@test "_util_path_append does not add duplicate entries" {
	local path_entries='/first:/second'
	_util_path_append path_entries '/first'
	_util_path_append path_entries '/second'
	assert_equal "$path_entries" '/first:/second'
}

@test "_util_path_append supports PATH without a variable argument" {
	local result=
	result=$(
		PATH='/first:/second'
		_util_path_append '/third'
		_util_path_append '/third'
		printf '%s' "$PATH"
	)
	assert_equal "$result" '/first:/second:/third'
}
