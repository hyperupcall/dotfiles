#!/usr/bin/env bats

set -o posix

_create_archive_1() {

}

_create_archive_2() {

}

@test "_result" {
	local result

	result="ls"

	[[ $result == 'ls' ]]
}
