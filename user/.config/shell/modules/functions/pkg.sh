# shellcheck shell=bash

_shell_pkg_get_pager() {
	local cmd=
	for cmd in bat batcat less; do
		if command -v "$cmd" &>/dev/null; then
			PKG_PAGER=$cmd
			return
		fi
	done; unset cmd

	PKG_PAGER="$PAGER"
}

pkgl() {
	local pkg=$1

	if command -v pacman &>/dev/null; then
		if pacman -Qi "$pkg" >/dev/null; then
			pacman -Ql "$pkg" | "$PKG_PAGER"
		else
			_shell_util_log_error "Package not found"
		fi
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgi() {
	local pkg=$1

	if command -v pacman &>/dev/null; then
		pacman -Qi "$pkg" | "$PKG_PAGER"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgo() {
	local pkg=$1

	if command -v pacman &>/dev/null; then
		pacman -Qo "$pkg" | "$_shell_pkg_pager"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}
