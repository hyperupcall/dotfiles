# shellcheck shell=bash

util.req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

util.run() {
	print.info "Executing '$*'"
	if "$@"; then
		return $?
	else
		return $?
	fi
}

util.ensure() {
	if "$@"; then :; else
		print.die "'$*' failed (code $?)"
	fi
}

util.is_cmd() {
	if command -v "$1" &>/dev/null; then
		return $?
	else
		return $?
	fi
}

util.ensure_bin() {
	if ! command -v "$1" &>/dev/null; then
		print.die "Command '$1' does not exist"
	fi
}

util.show_help() {
	cat <<-EOF
		Usage:
		  dotmgr [command]

		Commands:
		  bootstrap-stage1
		    Bootstrap operations that ocur before dotfiles have been deployed

		  action
		    Perform a particular action. If no action was given, show
		    a selection screen for the different actions

		  module [--list] [--show] [--edit] [stage]
		    Bootstraps dotfiles, only for a particular language

		Flags:
		  --help
		    Show help menu

		Examples:
		  dotmgr bootstrap-stage1
		  dotmgr module rust
	EOF
}
