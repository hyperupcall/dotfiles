# shellcheck shell=bash

# ------------------- helper functions ------------------- #
function show_help() {
	cat <<-EOF
		Usage:
		    dot.sh [command]

		Commands:
		    pre-bootstrap
		        Performs pre-bootstrap operations

		    bootstrap [stage]
		        Bootstraps dotfiles, optionally add a stage to skip some steps

		    misc
		        Reconciles state

		    info
		        Prints info

		Examples:
		    dot.sh bootstrap i_rust
	EOF
}

function die() {
	log_error "$*"
	exit 1
}

function req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

function log_info() {
	printf "\033[0;34m%s\033[0m\n" "INFO: $*"
}

function log_error() {
	printf "\033[0;31m%s\033[0m\n" "ERROR: $*" >&2
}

# sources profiles before boostrap
function source_profile() {
	[ -d ~/.dots ] && {
		set +u
		source ~/.dots/user/.profile
		set -u
		return
	}

	pushd "$(mktemp -d)" || die "Could not push temp dir"
	req -o temp-profile.sh https://raw.githubusercontent.com/eankeen/dots/main/user/.profile
	set +u
	source temp-profile.sh
	set -u
}

function pre-check() {
	ensure() {
		: "${1:?"Error: check_prerequisites: 'binary' command not passed"}"

		type "$1" >&/dev/null || {
			die "Error: '$1' not found. Exiting early"
		}
	}

	[[ $(id -un) = edwin ]] || {
		die "Error: 'id -un' not 'edwin'. Exiting early"
	}

	ensure git
	ensure zip # sdkman
	ensure make # g
	ensure pkg-config # starship
}
