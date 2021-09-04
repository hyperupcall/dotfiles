# shellcheck shell=bash


# -------------------------- run ------------------------- #

trap sigint INT
sigint() {
	set +x
	die 'Received SIGINT'
}


# -------------------- util functions -------------------- #

req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

die() {
	log_error "${*-'die: '}. Exiting"
	exit 1
}

ensure() {
	"$@" || die "'$*' failed"
}

log_info() {
	printf "\033[0;34m%s\033[0m\n" "INFO: $*"
}

log_warn() {
	printf "\033[1;33m%s\033[0m\n" "WARN: $*" >&2
}

log_error() {
	printf "\033[0;31m%s\033[0m\n" "ERROR: $*" >&2
}

check_bin() {
	command -v "$1" &>/dev/null || {
		log_error "Command '$1' NOT installed"
	}
}

check_dot() {
	# shellcheck disable=SC2088
	[ -e ~/"$1" ] && {
		log_error "File '$1' EXISTS"
	}
}


# ------------------- helper functions ------------------- #

util_show_help() {
	cat <<-EOF
		Usage:
		    dot.sh [command]

		Commands:
		    bootstrap
		        Performs pre-bootstrap operations

		    install [stage]
		        Bootstraps dotfiles, optionally add a stage to skip some steps
		    module
		        Does module

		    maintain
		        Reconciles state

		Examples:
		    dot.sh bootstrap
		    dot.sh install i_rust
	EOF
}



# sources profiles before boostrap
util_source_profile() {
	[ -d ~/.dots ] && {
		source ~/.dots/user/.profile
		return
	}

	pushd "$(mktemp -d)" || {
		log_error "Could not push temp dir"
		return 1
	}

	req -o temp-profile.sh https://raw.githubusercontent.com/eankeen/dots/main/user/.profile
	source temp-profile.sh

	popd || {
		log_error "Could not popd"
		return 1
	}
}
