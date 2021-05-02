# shellcheck shell=sh

# root
del() {
	if command -v trash-put >/dev/null 2>&1; then
		for f; do
			trash-put "$f" || {
				_profile_util_die "del: 'trash-put' failed"
				return
			}
		done
	elif command -v gio >/dev/null 2>&1; then
		for f; do
			gio trash "$f" || {
				_profile_util_die "del: 'gio trash' failed"
				return
			}
		done
	else
		_profile_util_log_die "del: Neither 'trash-cli' nor 'gio' installed"
		return
	fi
}
