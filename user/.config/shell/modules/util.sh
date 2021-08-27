# shellcheck shell=sh

# Common functions used in starup files for POSIX shell,
# Bash, and Zsh

_path_prepend() {
	[ -n "$2" ] && {
		# [ -d "$2" ] || return
		case ":$(eval "echo \$$1"):" in
			*":$2:"*) :;;
			*) eval "export $1=$2\${$1:+\":\$$1\"}" ;;
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
			*) eval "export $1=\${$1:+\"\$$1:\"}$2" ;;
		esac
		return
	}

	# [ -d "$1" ] || return
	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="${PATH:+"$PATH:"}$1"
	esac
}

_shell_util_log_error() {
	printf "\033[0;31m%s\033[0m\n" "Error: $*" >&2
}

_shell_util_log_warn() {
	printf "\033[1;33m%s\033[0m\n" "Warn: $*" >&2
}

_shell_util_log_info() {
	printf "\033[0;34m%s\033[0m\n" "Info: $*"
}

_shell_util_die() {
	_shell_util_log_error "$*"
	return 1
}

_shell_util_ls() {
	if command -v exa >/dev/null 2>&1; then
		exa -al
	elif command -v lsd >/dev/null 2>&1; then
		lsd -al
	else
		ls -al
	fi
}
