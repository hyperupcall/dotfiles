# shellcheck shell=bash

req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

die() {
	log_error "$1. Exiting"
	exit 1
}

ensure() {
	"$@" || die "'$*' failed"
}

log_info() {
	printf '%s\n' "$*"
	# printf "\033[0;34m%s\033[0m\n" "INFO: $*"
}

log_warn() {
	printf '%s\n' "Warn: $*"
	# printf "\033[1;33m%s\033[0m\n" "WARN: $*" >&2
}

log_error() {
	# printf '%s\n' "Error: $*"
	printf "\033[0;31m%s\033[0m\n" "Error: $*" >&2
}

check_bin() {
	if command -v "$1" &>/dev/null; then
		log_warn "Command '$1' NOT installed"
	fi
}

check_dot() {
	# shellcheck disable=SC2088
	if [ -e ~/"$1" ]; then
		log_warn "File '$1' EXISTS"
	fi
}


# ------------------- helper functions ------------------- #

util.show_help() {
	cat <<-EOF
		Usage:
		    dots-bootstrap [command]

		Commands:
		  bootstrap
		    Bootstraps the current user

		  module <stage>
		    Bootstraps dotfiles, only for a particular language

		  module-show <stage>
		    Print the contents of a module stage, to show what would be executed

		  maintain
		    Performs cleanup and ensures various files and symlinks exist

		  import-gpgkey [dir]
		    Imports gpgkey

		Examples:
		    dots-bootstrap bootstrap
		    dots-bootstrap module rust
	EOF
}
