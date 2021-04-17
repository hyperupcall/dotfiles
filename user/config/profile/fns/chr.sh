# shellcheck shell=sh

chr() {
	[ -z "$1" ] && { _profile_util_die "chr: No mountpoint specified"; return; }
	[ -d "$1" ] || { _profile_util_die "chr: Folder doesn't exist"; return; }

	command -v arch-chroot >/dev/null 2>&1 && {
		arch-chroot "$@"
		return
	}

	sudo mount -o bind -t proc /proc "$1/proc"
	sudo mount -o bind -t sysfs /sys "$1/sys"
	sudo mount -o bind -t tmpfs /run "$1/run"
	sudo mount -o bind -t devtmpfs /dev "$1/dev"

	[ "$TERM" = xterm-kitty ] && {
		TERM=xterm-256color
		sudo chroot "$1"
		TERM=xterm-kitty
		return
	}

	sudo chroot "$1"
}