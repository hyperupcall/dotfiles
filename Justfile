update:
	plataea config/user.dots/plataea.toml

build:
	cd user/scripts && \
		clang -Wall -Wpedantic show_shell.c \
			-o ../bin/show_shell

reload:
	xrdb ~/.config/Xresources
	i3-msg restart

lint:
	shfmt -bn -ci -kp -l -w .
	docker run --rm -v "$PWD:/work" tmknom/prettier --write '**/*.{json,md,mdx,yaml,yml}'
	fish -n "$1"
