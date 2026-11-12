#!/usr/bin/env bats

load ../../../vendor/bats-all/load.bash

@test "tracked Fish configuration files pass native syntax checks" {
	local repo_root="$BATS_TEST_DIRNAME/../../.."
	local -a files=()
	mapfile -d '' -t files < <(git -C "$repo_root" ls-files -z -- 'config-shell/.config/fish/*.fish')
	assert [ "${#files[@]}" -gt 0 ]

	local file=
	for file in "${files[@]}"; do
		run fish --no-execute "$repo_root/$file"
		assert_success
	done
}
