#!/usr/bin/env bats

set -o posix

@test "_result" {
	local result

	result="ls"

	[[ $result == 'ls' ]]
}
