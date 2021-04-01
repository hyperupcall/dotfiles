# shellcheck shell=sh

# cloned in /root/.bashrc
cdls() {
	cd -- "$1" || { _profile_util_die "cdls: cd failed"; return; }
	_profile_util_ls
}

# cloned in /root/.bashrc
mkcd() {
	command mkdir -p -- "$@"
	cd -- "$@" || { _profile_util_die "mkcd: could not cd"; return; }
}
