# shellcheck shell=sh

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

r() {
	for _file; do
		if [ -d "$_file" ]; then
			command rmdir "$_file"
		else
			command rm "$_file"
		fi
	done
	unset -v _file
}

t() {
	if [ $# -eq 0 ]; then
		_util_log_error 't: Missing file arguments'
		return
	fi

	for _file; do
		mkdir -p "${_file%/*}"
		command touch "$_file"
	done
	unset -v _file
}

v() {
	s=
	if [ -e "$1" ] && [ "$(stat -c "%G" "$1")" = 'root' ]; then
		s='sudo'
	fi

	_v_editor="${VISUAL:-vi}"
	if [ $# -eq 0 ]; then
		"$_v_editor" .
	else
		$s mkdir -p "${1%/*}"
		$s "$_v_editor" "$@"
	fi
	unset -v _v_editor
}

del() {
	if command -v trash-put >/dev/null 2>&1; then
		for f; do
			if ! trash-put "$f"; then
				_util_log_error "del: 'trash-put' failed"
				return 1
			fi
		done
	elif command -v gio >/dev/null 2>&1; then
		for f; do
			if ! gio trash "$f"; then
				_util_log_error "del: 'gio trash' failed"
				return 1
			fi
		done
	else
		_util_log_warn "del: Neither 'trash-cli' nor 'gio' installed. Skipping"
	fi
}

cdls() {
	if ! cd -- "$1"; then
		_util_log_error "cdls: Failed to cd"
		return 1
	fi
	_util_ls
}

mkcd() {
	command mkdir -p -- "$@"
	if ! cd -- "$@"; then
		_util_log_error "mkcd: Failed to cd"
		return 1
	fi
}

mkmv() {
	for last_arg; do :; done
	mkdir -p "$last_arg"

	mv "$@"
}
