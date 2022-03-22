# shellcheck shell=bash

task.build() {
	cd ./user/scripts
	# clang -Wall -Wpedantic show_shell.c -o ../bin/show_shell

	cd "$BAKE_ROOT/user/.config/X11/resources"
	printf '%s\n' "! GENERATERD BY 'bake build'" > uxterm.Xresources
	sed 's/XTerm/UXTerm/g' xterm.Xresources >> uxterm.Xresources
}

task.update-subtree() {
	git subtree --squash -P vendor/bats-all pull 'https://github.com/hyperupcall/bats-all' HEAD
}

task.test() {
	cd ./user/.config/shell/modules && bats -p .
}

task.commit() {
	git commit -m "Update: $(date "+%B %d, %Y (%H:%M)")" "$@"
}
