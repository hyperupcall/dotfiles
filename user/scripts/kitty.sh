#!/usr/bin/env sh

[ -z "$XDG_RUNTIME_DIR" ] && {
	echo "kitty.sh: Error: XDG_RUNTIME_DIR not set"
	exit 1
}
mkdir -p "$XDG_RUNTIME_DIR/kitty"

n=1
while true; do
	[ ! -S "$XDG_RUNTIME_DIR/kitty/control-socket-$n" ] && break
	n=$((n + 1))
done

exec kitty \
	-o allow_remote_control=yes \
	--listen-on unix:"$XDG_RUNTIME_DIR/kitty/control-socket-$n"
