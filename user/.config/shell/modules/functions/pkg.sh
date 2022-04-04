# shellcheck shell=bash

pkg() {
	printf '%s\n' "Functions:
  pkgi: Install a package
  pkgl: List contents of package
  pkgp: see package Providing a file
  pkgs: Search for a package"
}

pkgi() {
	local pkg="$1"

	if _shell_util_has 'pacman'; then
		sudo 'pacman' -S "$pkg"
	elif _shell_util_has 'dnf'; then
		sudo 'dnf' install "$pkg"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgl() {
	local pkg="$1"

	if _shell_util_has 'pacman'; then
		'pacman' -Ql "$pkg"
	elif _shell_util_has 'dnf'; then
		'rpm' -ql "$pkg"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgp() {
	local pkg="$1"

	if _shell_util_has 'pacman'; then
		'pacman' -Qo "$pkg"
	elif _shell_util_has 'dnf'; then
		'dnf' provides "$1"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgs() {
	local pkg="$1"

	if _shell_util_has 'pacman'; then
		'pacman' -Q "$pkg"
	elif _shell_util_has 'dnf'; then
		'dnf' search "$pkg"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}
