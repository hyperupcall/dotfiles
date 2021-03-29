# shellcheck shell=sh

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

# cloned in /root/.bashrc
r() {
	for file; do
		if [ -d "$file" ]; then
			command rmdir "$file"
		else
			command rm "$file"
		fi
	done
}

# cloned in /root/.bashrc
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

# cloned in /root/.bashrc
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
