# shellcheck shell=sh

# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there/1644866#1644866
_util_path_prepend() {
	if [ -n "$2" ]; then
		if [ -n "${BASH_VERSION:-}" ]; then
			# shellcheck disable=SC3043
			local -n _path="$1"
			case ":$_path:" in
			*":$2:"*) : ;;
			*) export "$1=$2${_path:+":$_path"}" ;;
			esac
			# shellcheck disable=SC3045
			unset -vn _path
		else
			case :$(eval "printf '%s' \"\$$1\""): in
			*":$2:"*) : ;;
			*) eval "export $1=$2\${$1:+\":\$$1\"}" ;;
			esac
		fi
		return
	fi

	case ":$PATH:" in
	*":$1:"*) : ;;
	*) export PATH="$1${PATH:+":$PATH"}" ;;
	esac
}

_util_path_append() {
	if [ -n "$2" ]; then
		if [ -n "${BASH_VERSION:-}" ]; then
			# shellcheck disable=SC3043
			local -n _path="$1"
			case ":$_path:" in
			*":$2:"*) : ;;
			*) export "$1=${_path:+":$_path"}$2" ;;
			esac
			# shellcheck disable=SC3045
			unset -vn _path
		else
			case :$(eval "printf '%s' \"\$$1\""): in
			*":$2:"*) : ;;
			*) eval "export $1=\${$1:+\"\$$1:\"}$2" ;;
			esac
		fi
		return
	fi

	case ":$PATH:" in
	*":$1:"*) : ;;
	*) export PATH="${PATH:+"$PATH:"}$1" ;;
	esac
}

_util_source_file() {
	# Software such as "ble.sh" will error since the "inherited"
	# positional parameters are non-zero. So, ensure there isn't any.
	_file=$1
	shift

	. "$_file"

	# shellcheck disable=SC2181
	[ $? -ne 0 ] && _util_print_source_error "$_file"
	unset -v _file
}

_util_source_dir() {
	for _dir; do
		_dir=${_dir%/}
		if [ -d "$_dir" ]; then
			for _file in "$_dir"/*; do
				if [ -f "$_file" ]; then
					_util_source_file "$_file"
				fi
			done
			unset -v _file
		else
			_util_log_warn "_util_source_dir: Not a directory: \"$_dir\""
		fi
	done
	unset -v _dir
}

_util_confirm() {
	_message=${1:-Confirm?}
	_args='-rN1'
	if [ -n "${ZSH_VERSION:-}" ]; then
		_args='-rsk'
	fi

	_input=
	until [ "$_input" = y ] || [ "$_input" = Y ] || [ "$_input" = n ] || [ "$_input" = N ]; do
		printf '%s' "$_message "
		# shellcheck disable=SC2086
		read -r ${_args?}
		_input=$REPLY
		printf '\n'
	done

	unset -v _message _args
	if [ "$_input" = y ] || [ "$_input" = Y ]; then
		unset -v _input
		return 0
	else
		unset -v _input
		return 1
	fi
}

_util_log_error() {
	if _util_should_print_color; then
		printf "\033[0;31m%s\033[0m %s\n" 'Error:' "$1" >&2
	else
		printf "%s %s\n" 'Error:' "$1" >&2
	fi
}

_util_log_warn() {
	if _util_should_print_color; then
		printf "\033[1;33m%s\033[0m %s\n" 'Warn:' "$1" >&2
	else
		printf "%s %s\n" 'Warn:' "$1" >&2
	fi
}

_util_log_info() {
	if _util_should_print_color; then
		printf "\033[0;34m%s\033[0m %s\n" 'Info:' "$1"
	else
		printf "%s %s\n" 'Info:' "$1"
	fi
}

_util_print_source_error() {
	_util_log_warn "Failed to source $1 successfully"
}

_util_ls() {
	printf '%s\n' '---'
	if command -v eza >/dev/null 2>&1; then
		eza -a --color=always
	else
		ls -A --color=always
	fi
	printf '%s\n' '---'
}

_util_should_print_color() {
	if [ ${NO_COLOR+x} ]; then
		return 1
	fi

	case $FORCE_COLOR in
	1 | 2 | 3) return 0 ;;
	0) return 1 ;;
	esac

	if [ "$TERM" = 'dumb' ]; then
		return 1
	fi

	if [ -t 0 ]; then
		return 0
	fi

	return 1
}
