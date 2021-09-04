#!/usr/bin/env bats

@test "Symlinks to xdg-user-dirs" {
	for dir in Dls Docs Music Pics Vids; do
		[[ -L ~/$dir ]]
	done
}
