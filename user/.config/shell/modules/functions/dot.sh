# shellcheck shell=bash

if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
	.gcc() {
		_shell_util_run gcc -std=c2x -Wall -Wextra -Wpedantic -Wconversion -fno-omit-frame-pointer "$@"
	}

	.gpp() {
		_shell_util_run g++ -std=c++20 -Wall -Wextra -Wpedantic -Wconversion -fno-omit-frame-pointer "$@"
	}

	.clang() {
		_shell_util_run clang -std=c2x -Wall -Wextra -Wpedantic -Wconversion -fno-omit-frame-pointer -fsanitize=address "$@"
	}

	.clangpp() {
		_shell_util_run clang++ -std=c++20 -Wall -Wextra -Wpedantic -Wconversion -fno-omit-frame-pointer -fsanitize=address "$@"
	}
fi
