#!/usr/bin/env bash

set -Eo pipefail

declare -r DIR="$HOME/.dots/user/scripts"

# --------------------- pre-bootstrap -------------------- #
do_pre-bootstrap() {
	source "$DIR/dot/pre-bootstrap.sh"

	source ~/.profile
	[[ -n $BASH ]] && source ~/.bashrc

	fn="${1:-}"
	[[ -n $fn ]] && {
		"$fn"
		return
	}

}

# ----------------------- bootstrap ---------------------- #
do_bootstrap() {
	source "$DIR/dot/bootstrap.sh"

	pre-check

	if [[ -n ${1:-} ]]; then
		"$1"
		return
	else
		install_packages
		i_rust
		i_node
		i_dvm
		i_ruby
		i_python
		i_nim
		i_zsh
		i_java
		i_tmux
		i_bash
		i_go
		i_php
		i_perl
		i_crystal
		i_haskell
		bootstrap_done
	fi
}

# ---------------------- maintenance --------------------- #
do_maintenance() {
	source "$DIR/dot/maintenance.sh"
}


## start ##
source "$DIR/dot/util.sh"

[[ $* =~ (--help) ]] && {
	show_help
	exit 0
}

[[ ${BASH_SOURCE[0]} != "$0" ]] && {
	log_info "Info: Sourcing detected. Sourcing old profile and exiting"
	source_profile
	return 0
}

case "${1:-''}" in
pre-bootstrap)
	shift
	do_pre-bootstrap "$@"
	;;
bootstrap)
	shift
	do_bootstrap "$@"
	;;
maintenance)
	shift
	do_maintenance "$@"
	;;
reload)
	shift
	do_reload "$@"
	;;
*)
	log_error "Error: No matching subcommand found"
	show_help
	exit 1
	;;
esac
