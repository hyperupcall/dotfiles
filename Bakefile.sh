# shellcheck shell=bash

task.build() {
	cd user/scripts
	# clang -Wall -Wpedantic show_shell.c -o ../bin/show_shell

	cd "$BAKE_ROOT/user/.config/X11/resources"
	printf '%s\n' "! GENERATERD BY 'bake build'" > uxterm.Xresources
	sed 's/XTerm/UXTerm/g' xterm.Xresources  >> uxterm.Xresources
}

task.test() {
	cd user/config/bash && bats -p .
}
