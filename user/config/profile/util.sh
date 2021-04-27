# shellcheck shell=sh

# single-use
_path_prepend() {
	[ -n "$2" ] && {
		# [ -d "$2" ] || return
		case ":$(eval "echo \$$1"):" in
			*":$2:"*) :;;
			*) eval "export $1=$2$(eval "echo \${$1:+\":\$$1\"}")" ;;
		esac
		return
	}

	# [ -d "$1" ] || return
	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$1${PATH:+":$PATH"}"
	esac
}

_path_append() {
	[ -n "$2" ] && {
		# [ -d "$2" ] || return
		case ":$(eval "echo \$$1"):" in
			*":$2:"*) :;;
			*) eval "export $1=$(eval "echo \${$1:+\"\$$1:\"}")$2" ;;
		esac
		return
	}

	# [ -d "$1" ] || return
	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="${PATH:+"$PATH:"}$1"
	esac
}

# runtime
_profile_util_log_error() {
	printf "\033[0;31m%s\033[0m\n" "Error: $*" >&2
}

_profile_util_log_warn() {
	printf "\033[1;33m%s\033[0m\n" "Warn: $*" >&2
}

_profile_util_log_info() {
	printf "\033[0;34m%s\033[0m\n" "Info: $*"
}

_profile_util_die() {
	_profile_util_log_error "$*"
	return 1
}

_profile_util_ls() {
	command -v exa >/dev/null 2>&1 && {
		exa -al
		return
	}

	ls -al
}
