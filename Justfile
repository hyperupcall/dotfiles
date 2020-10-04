build:
	cd scripts && \
		clang -Wall -Wpedantic show_shell.c \
			-o show_shell
	install scripts/show_shell ~/.local/bin

reload:
	xmerge
