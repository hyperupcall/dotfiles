# shellcheck shell=sh

# root
cdls() {
	cd -- "$1" || { _profile_util_die "cdls: cd failed"; return; }
	_profile_util_ls
}

# root
mkcd() {
	command mkdir -p -- "$@"
	cd -- "$@" || { _profile_util_die "mkcd: could not cd"; return; }
}
