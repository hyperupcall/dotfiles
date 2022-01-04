# shellcheck shell=sh

# clone(user, root)
del() {
	if command -v trash-put >/dev/null 2>&1; then
		for f; do
			if ! trash-put "$f"; then
				_shell_util_die "del: 'trash-put' failed"
				return
			fi
		done
	elif command -v gio >/dev/null 2>&1; then
		for f; do
			if ! gio trash "$f"; then
				_shell_util_die "del: 'gio trash' failed"
				return
			fi
		done
	else
		_shell_util_log_error "del: Neither 'trash-cli' nor 'gio' installed. Falling back to 'rm'"
		rm -rf "$@"
	fi
}
