#!/usr/bin/env bash
set -eo pipefail

source "$PROGRAM_LIB_DIR/util.sh"

trap sigint INT
sigint() {
	die 'Received SIGINT'
}

if ((EUID == 0)); then
	die "Cannot run as root"
fi

for arg; do case "$arg" in
-h|--help)
	util.show_help
	exit
	;;
esac done

case "$1" in
bootstrap)
	shift
	source "$PROGRAM_LIB_DIR/commands/bootstrap.sh"
	;;
module)
	shift
	source "$PROGRAM_LIB_DIR/commands/module.sh"
	;;
maintain)
	shift
	source "$PROGRAM_LIB_DIR/commands/maintain.sh"
	;;
*)
	log_error "No matching subcommand found"
	util.show_help
	exit 1
	;;
esac
