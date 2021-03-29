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

_stty_saved_settings="$(stty -g)"
stty() {
	if [ $# -eq 1 ] && [ "$1" = "sane" ]; then
		# 'stty sane' resets our modifications to behaviors of tty device
		# including the line discipline. this assumes tty was sane when initialized
		stty "$_stty_saved_settings"
		_stty_exit_code="$?"

		# redirect log to error since this could be a scripted command used within a tty
		_profile_util_log_info "stty: Restored stty settings to our default" 1>&2

		return "$_stty_exit_code"
	else
		command stty "$@"
	fi
}

touch() {
	_profile_util_die "touch: Use 't' instead"
	return
}

# cloned in /root/.bashrc
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
