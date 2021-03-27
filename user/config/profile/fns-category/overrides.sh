# shellcheck shell=sh

cp() {
	if command -v rsync >/dev/null 2>&1; then
		'rsync' -ah --progress "$@"
	else
		_profile_util_log_warn "cp: Falling back to 'cp'"
		command cp -i "$@"
	fi
}

rm() {
	_profile_util_die "rm: Use 'del' or 'r' instead"
	return
}

rmdir() {
	_profile_util_die "rmdir: Use 'r' instead"
	return
}

touch() {
	_profile_util_die "touch: Use 't' instead"
	return
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

vim() {
	_profile_util_log_error "vim: Use 'v' instead"
	return
}
