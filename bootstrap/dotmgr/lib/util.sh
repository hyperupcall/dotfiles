# shellcheck shell=bash

req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

die() {
	log_error "$1. Exiting"
	exit 1
}

ensure() {
	"$@" || die "'$1' failed"
}

log_info() {
	printf '%s\n' "$1"
}

log_warn() {
	printf '%s\n' "Warn: $1"
}

log_error() {
	printf '%s\n' "Error: $1"
}

check_bin() {
	if command -v "$1" &>/dev/null; then
		log_warn "Command '$1' NOT installed"
	fi
}

check_dot() {
	if [ -e "$HOME/$1" ]; then
		log_warn "File or directory '$1' EXISTS"
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

		  maintain
		    Performs cleanup and ensures various files and symlinks exist

		  save-state
		    Saves current state, like current VSCode extensions, etc. to
		    various files

		Examples:
		  dotmgr bootstrap-stage1
		  dotmgr module rust
	EOF
}
