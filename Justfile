build:
	cd user/scripts && \
		clang -Wall -Wpedantic show_shell.c \
			-o ../bin/show_shell

test:
	cd user/config/bash && bats -p .
