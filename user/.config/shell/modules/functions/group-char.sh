# shellcheck shell=sh

# run alias only
# clone(user, root)
a() {
	# TODO: BASH_ALIASES
	if alias "$1" >/dev/null 2>&1; then
		_a_aliasValue="$(alias "$1" | awk -v FS="'" '{ print $2 }')"

		# history -s "$_a_aliasValue"
		# history -s "$1"
		$_a_aliasValue
	else
		_shell_util_die "a: Alias '$1' not found"
		return
	fi
}

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

# clone(user, root)
r() {
	for file; do
		if [ -d "$file" ]; then
			command rmdir "$file"
		else
			command rm "$file"
		fi
	done
	unset -v file
}

# clone(user, root)
s() {
	BASH_ENV="/root/.bashrc" sudo -i --preserve-env=BASH_ENV "$@"
}

# clone(user, root)
t() {
	[ $# -eq 0 ] && {
		_shell_util_log_error 't: Missing file arguments'
		return
	}

	for arg; do
		case "$arg" in
		-a*|-c*|--no-create*|-d*|--date*|-f*|-h*|--no-dereference*|-m*|-r*|--reference*|-t*|--time*|--help*|--version*|--)
			_shell_util_log_die "t: Args detected. Please use 'touch'"
			return
			;;
		esac
	done
	unset -v arg

	for file; do
		mkdir -p "$(dirname "$file")"
		command touch "$file"
	done
	unset -v file
}

# clone(user, root)
v() {
	s=
	if [ -e "$1" ] && [ "$(stat -c "%G" "$1")" = "root" ]; then
		s="sudo"
	fi

	_v_editor="${EDITOR:-vi}"

	if [ $# -eq 0 ]; then
		"$_v_editor" .
	else
		[ $# -eq 1 ] && $s mkdir -p "$(dirname "$1")"
		$s "$_v_editor" "$@"
	fi

	unset -v _v_editor
}
