# shellcheck shell=sh

# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there/1644866#1644866
_util_path_prepend() {
	if [ -n "$2" ]; then
		case ":$(eval "printf '%s' \"\$$1\""):" in
			*":$2:"*) :;;
			*) eval "export $1=$2\${$1:+\":\$$1\"}" ;;
		esac
		return
	fi

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$1${PATH:+":$PATH"}"
	esac
}

_util_path_append() {
	if [ -n "$2" ]; then
		case ":$(eval "printf '%s' \"\$$1\""):" in
			*":$2:"*) :;;
			*) eval "export $1=\${$1:+\"\$$1:\"}$2" ;;
		esac
		return
	fi

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="${PATH:+"$PATH:"}$1"
	esac
}

_util_die() {
	_util_log_error "$*"
	return 1
}

_util_log_error() {
	if [ -t 0 ]; then
		printf "\033[0;31m%s\033[0m %s\n" 'Error:' "$1" >&2
	else
		printf "%s %s\n" 'Error:' "$1" >&2
	fi
}

_util_log_warn() {
	if [ -t 0 ]; then
		printf "\033[1;33m%s\033[0m %s\n" 'Warn:' "$1" >&2
	else
		printf "%s %s\n" 'Warn:' "$1" >&2
	fi
}

_util_log_info() {
	if [ -t 0 ]; then
		printf "\033[0;34m%s\033[0m %s\n" 'Info:' "$1"
	else
		printf "%s %s\n" 'Info:' "$1"
	fi
}

_util_ls() {
	printf '%s\n' '---'
	if command -v exa >/dev/null 2>&1; then
		exa -a --color=always
	else
		ls -A --color=always
	fi
	printf '%s\n' '---'
}

_util_has() {
	if hash "$1" >/dev/null 2>&1; then
		return 0
	else
		return 1
	fi
}

_util_run() {
	_util_log_info "Executing: $*"

	if "$@"; then :; else
		return $?
	fi
}
