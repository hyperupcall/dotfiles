# shellcheck shell=bash

global.trap_exit() {
	if type -t tty.fullscreen_deinit &>/dev/null; then
		tty.fullscreen_deinit
	fi
}

main.dotmgr() {
	set -eo pipefail
	shopt -s dotglob nullglob shift_verbose
	trap 'global.trap_exit' EXIT

	source "$DOTMGR_ROOT_DIR/src/util/print.sh"
	source "$DOTMGR_ROOT_DIR/src/util/util.sh"

	local arg=
	for arg; do case $arg in
	-h|--help)
		util.show_help
		exit
		;;
	esac done; unset -v arg

	local subcommand="$1"
	if [ -f "$DOTMGR_ROOT_DIR/src/commands/$subcommand.sh" ]; then
		if ! shift; then
			print.die "Failed to shift"
		fi
		source "$DOTMGR_ROOT_DIR/src/commands/$subcommand.sh" "$@"
		subcommand "$@"
	else
		util.show_help
		print.error "No matching subcommand found"
		exit 1
	fi
}
