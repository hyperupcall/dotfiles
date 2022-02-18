# shellcheck shell=bash

bake.build() {
	cd user/scripts
	clang -Wall -Wpedantic show_shell.c \
			-o ../bin/show_shell
}

bake.test() {
	cd user/config/bash && bats -p .
}
