# shellcheck shell=sh

#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

del() {
	if command -v trash-put >/dev/null 2>&1; then
		for f; do
			trash-put "$f" || {
				_profile_util_log_die "del: 'trash-put' failed"
				return
			}
		done
	elif command -v gio >/dev/null 2>&1; then
		for f; do
			gio trash "$f" || {
				_profile_util_log_die "del: 'gio trash' failed"
				return
			}
		done
	else
		_profile_util_log_die "del: Neither 'trash-cli' nor 'gio' installed"
		return
	fi
}

cdls() {
	cd "$1" || { _profile_util_die "cdls: cd failed"; return; }
	_profile_util_ls
}

mkcd() {
	command mkdir -p -- "$@"
	cd -- "$@" || { _profile_util_die "mkcd: could not cd"; return; }
}

unlink() {
	for arg; do
		case "$arg" in
		--help|--version)
			command unlink "$@"
			return
			;;
		esac
	done

	for file; do
		command unlink "$file"
	done
}

r() {
	for file; do
		if [ -d "$file" ]; then
			command rmdir "$file"
		else
			command rm "$file"
		fi
	done
}

t() {
	[ $# -eq 0 ] && {
		_profile_util_log_error 't: Missing file arguments'
		return
	}

	for arg; do
		case "$arg" in
		-a*|-c*|--no-create*|-d*|--date*|-f*|-h*|--no-dereference*|-m*|-r*|--reference*|-t*|--time*|--help*|--version*|--)
			_profile_util_log_die "t: Args detected. Please use 'touch'"
			return
			;;
		esac
	done

	for file; do
		mkdir -p "$(dirname "$file")"
		command touch "$file"
	done
}

v() {
	_v_editor="${EDITOR:-vi}"

	if [ $# -eq 0 ]; then
		"$_v_editor" .
	else
		mkdir -p "$(dirname "$1")"
		"$_v_editor" "$1"
	fi

	unset -v _v_editor
}
