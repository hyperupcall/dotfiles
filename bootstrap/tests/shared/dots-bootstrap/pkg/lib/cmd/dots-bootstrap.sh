#!/usr/bin/env bash
set -Eo pipefail

## start ##
source "$PROGRAM_LIB_DIR/util.sh"

((EUID == 0)) && {
	die "Cannot run as root"
}

for arg; do [[ $arg =~ (-h|--help) ]] && {
	util_show_help
	exit
}; done

case "$1" in
bootstrap)
	shift
	source "$PROGRAM_LIB_DIR/bootstrap.sh"
	;;
install)
	shift
	source "$PROGRAM_LIB_DIR/install.sh"
	;;
module)
	shift
	source "$PROGRAM_LIB_DIR/module.sh"
	;;
maintain)
	shift
	source "$PROGRAM_LIB_DIR/maintain.sh"
	;;
*)
	log_error "Error: No matching subcommand found"
	util_show_help
	exit 1
	;;
esac
