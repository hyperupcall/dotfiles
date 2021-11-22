# shellcheck shell=bash

util.req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

util.run() {
	util.log_info "Executing '$*'"
	if "$@"; then
		return $?
	else
		return $?
	fi
}

util.die() {
	util.log_error "$1. Exiting"
	exit 1
}

util.log_error() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%s: %s\n" "Error" "$1"
	else
		printf "\033[0;31m%s\033[0m %s\n" 'Error' "$1"
	fi
}

util.log_warn() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%s: %s\n" 'Warning' "$1" >&2
	else
		printf "\033[0;33m%s\033[0m %s\n" 'Warning' "$1" >&2
	fi
}

util.log_info() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%s: %s\n" 'Info' "$1" >&2
	else
		printf "\033[0;32m%s\033[0m %s\n" 'Info' "$1" >&2
	fi
}

util.ensure() {
	if "$@"; then :; else
		util.die "'$*' failed (zcode $?)"
	fi
}

util.ensure_bin() {
	if ! command -v "$1" &>/dev/null; then
		util.die "Command '$1' does not exist"
	fi
}

# TODO: deprecate
check_bin() {
	if command -v "$1" &>/dev/null; then
		util.log_warn "Command '$1' does not exist"
	fi
}

util.show_help() {
	cat <<-EOF
		Usage:
		  dotmgr [command]

		Commands:
		  bootstrap-stage1
		    Bootstrap operations that ocur before dotfiles have been deployed

		  bootstrap-stage2
		    Bootstrap operations that occur after dotfiles have been deployed

		  module [--list] [--show <stage>] [stage]
		    Bootstraps dotfiles, only for a particular language

		  refresh
		    Refresh dotfiles, removing any stuff that might have automatically been
		    appended by installation scripts

		  maintain
		    Performs cleanup and ensures various files and symlinks exist

		  transfer
		    Transfers ssh and gpg keys to and from a USB

		  save-state
		    Saves current state, like current VSCode extensions, etc. to
		    various files

		Examples:
		  dotmgr bootstrap-stage1
		  dotmgr module rust
	EOF
}
