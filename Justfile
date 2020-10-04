build:
	cd scripts && \
		clang -Wall -Wpedantic show_shell.c \
			-o show_shell
	install scripts/show_shell ~/.local/bin

reload:
	xrdb ~/.config/Xresources
	i3-msg restart

lint:
   shfmt -bn -ci -kp -l -w .
	docker run --rm -v "$PWD:/work" tmknom/prettier --write '**/*.{json,md,mdx,yaml,yml}'
