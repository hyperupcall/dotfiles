# shellcheck shell=bash


main.dotmgr() {
	set -eo pipefail
	shopt -s dotglob extglob globstar nullglob shift_verbose
	local f=
	for f in "$DOTMGR_ROOT"/src/{helpers,util}/?*.sh; do
		source "$f"
	done; unset -v f
	for f in "$DOTMGR_ROOT"/vendor/bash-core/pkg/src/{public,util}/?*.sh; do
		source "$f"
	done; unset -v f
	util.prereq

	local arg=
	for arg; do case $arg in
	-h|--help)
		util.show_help
		exit
		;;
	esac done; unset -v arg

	local subcommand="$1"
	if [ -f "$DOTMGR_ROOT/src/commands/$subcommand.sh" ]; then
		if ! shift; then
			print.die "Failed to shift"
		fi
		source "$DOTMGR_ROOT/src/commands/$subcommand.sh"
		subcommand "$@"
	else
		util.show_help
		print.error 'No matching subcommand found'
		exit 1
	fi
}
