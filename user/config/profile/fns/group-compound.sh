# shellcheck shell=sh

# clone(user, root)
cdls() {
	cd -- "$1" || { _shell_util_die "cdls: cd failed"; return; }
	_shell_util_ls
}

# clone(user, root)
mkcd() {
	command mkdir -p -- "$@"
	cd -- "$@" || { _shell_util_die "mkcd: could not cd"; return; }
}

# clone(user, root)
mkmv() {
	for lastArg; do true; done
	mkdir -p "$lastArg"

	mv "$@"
}
