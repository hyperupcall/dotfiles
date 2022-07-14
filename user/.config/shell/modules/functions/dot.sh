# shellcheck shell=bash

if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
	ggcc() {
		_shell_util_run gcc -std=c2x -Wall -Wextra -Wpedantic -Wconversion -Wshadow-compatible-local -fno-omit-frame-pointer -fsanitize=address "$@"
	}

	ggpp() {
		_shell_util_run g++ -std=c++20 -Wall -Wextra -Wpedantic -Wconversion -Wshadow-compatible-local -fno-omit-frame-pointer -fsanitize=address "$@"
	}

	gclang() {
		_shell_util_run clang -std=c2x -Wall -Wextra -Wpedantic -Wconversion -Wshadow-compatible-local -fno-omit-frame-pointer -fsanitize=address "$@"
	}

	clangpp() {
		_shell_util_run clang++ -std=c++20 -Wall -Wextra -Wpedantic -Wconversion -Wshadow-compatible-local -fno-omit-frame-pointer -fsanitize=address "$@"
	}
fi
