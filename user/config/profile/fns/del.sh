# shellcheck shell=sh

# clone(user, root)
del() {
	if command -v trash-put >/dev/null 2>&1; then
		for f; do
			trash-put "$f" || {
				_shell_util_die "del: 'trash-put' failed"
				return
			}
		done
	elif command -v gio >/dev/null 2>&1; then
		for f; do
			gio trash "$f" || {
				_shell_util_die "del: 'gio trash' failed"
				return
			}
		done
	else
		_shell_util_log_error "del: Neither 'trash-cli' nor 'gio' installed. Falling back to 'rm'"
		rm -rf "$@"
	fi
}
