# shellcheck shell=bash


main.dotmgr() {
	set -eo pipefail
	shopt -s dotglob extglob globstar nullglob shift_verbose
	source "$DOTMGR_ROOT_DIR/src/util/print.sh"
	source "$DOTMGR_ROOT_DIR/src/util/util.sh"
	# trap 'util.trap_winch' 'WINCH' # FIXME does not work
	util.prereq

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
		source "$DOTMGR_ROOT_DIR/src/commands/$subcommand.sh"
		subcommand "$@"
	else
		util.show_help
		print.error 'No matching subcommand found'
		exit 1
	fi
}
