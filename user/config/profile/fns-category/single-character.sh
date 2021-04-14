# shellcheck shell=sh

# TODO fix
a() {
	if alias "$1" >/dev/null 2>&1; then
		_a_aliasValue="$(alias "$1" | awk -v FS="'" '{ print $2 }')"
		# history -s "$_a_aliasValue"
		# history -s "$1"
		$_a_aliasValue
	else
		_profile_util_die "a: Alias '$1' not found"
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

# cloned in /root/.bashrc
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

# TODO
s() {
	BASH_ENV="/root/.bashrc" sudo -i --preserve-env=BASH_ENV "$@"
	# BASH_ENV="/root/.bashrc" sudo -i --preserve-env=BASH_ENV "cd $(pwd) && $*"
	# BASH_ENV="/root/.bashrc" sudo -i --preserve-env=BASH_ENV <<-EOF
	# source  /root/.bashrc
	# cd "$(pwd)"
	# $@
	# EOF
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
	unset -v arg

	for file; do
		mkdir -p "$(dirname "$file")"
		command touch "$file"
	done
	unset -v file
}

# cloned in /root/.bashrc
v() {
	_v_editor="${EDITOR:-vi}"

	if [ $# -eq 0 ]; then
		"$_v_editor" .
	else
		[ $# -eq 1 ] && mkdir -p "$(dirname "$1")"

		"$_v_editor" "$@"
	fi

	unset -v _v_editor
}
