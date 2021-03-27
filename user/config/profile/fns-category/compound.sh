# shellcheck shell=sh

cdls() {
	cd "$1" || { _profile_util_die "cdls: cd failed"; return; }
	_profile_util_ls
}

mkcd() {
	command mkdir -p -- "$@"
	cd -- "$@" || { _profile_util_die "mkcd: could not cd"; return; }
}
