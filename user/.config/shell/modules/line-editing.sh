# shellcheck shell=bash

# @file line-editing.sh
# @brief Common functions for both Bash-configured GNU Readline
# and Zsh's Zle

# gets line ($1), and removes
# sudo, ', ", and extra whitespaces
_readline_util_get_line() {
	REPLY=
	local line="$1"

	# trim environment variables
	line="${line##*=* }"

	_readline_util_trim_whitespace "$line"
	line="$REPLY"

	if [ "${line:0:4}" = "sudo" ]; then
		line="${line:4}"
	fi

	_readline_util_trim_whitespace "$line"
	line="$REPLY"

	# Ex. 'grep', \grep
	line="${line/\\/}"
	line="${line/\'/}"
	line="${line/\'/}"
	line="${line/\"/}"
	line="${line/\"/}"

	REPLY="$line"
}

_readline_util_expand_alias() {
	local line="$1"

	local cmd="${line%% *}"
	if alias "$cmd" &>/dev/null; then
		line="$(alias "$cmd")"
		line="${line#*=\'}"
		line="${line%\'}"
	fi

	REPLY="$line"
}

_readline_util_get_cmd() {
	REPLY=
	# shellcheck disable=SC1007
	local line= cmd=

	_readline_util_get_line "$1"

	cmd="${REPLY%%\ *}"

	REPLY="$cmd"
}

# shellcheck disable=SC2181
_readline_util_try_show_help() {
	local line cmd helpText
	line="$1"
	_readline_util_get_cmd "$line"
	cmd="$REPLY"

	if ! helpText="$($line --help)"; then
		if ! helpText="$($line -h)"; then
			if ! helpText="$($line help)"; then
				return 1
			fi
		fi
	fi

	printf '%s\n' "$helpText"
	return
}

_readline_util_try_show_man() {
	local manual="$1"

	if command man "$manual" 2>/dev/null; then
		return
	else
		local exitStatus=$?

		if ((exitStatus != 16)); then
			log_error "'man' invocation error"

			# By returning success, no more man pages will be searched
			return 0
		else
			return $exitStatus
		fi
	fi
}

_readline_util_x_discard() {
	local buf="$1"
	local pos="$2"

	xclip -selection clipboard <<< "${buf:0:$pos}"
	buf="${buf:$pos}"
	pos=0

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_x_kill() {
	local buf="$1"
	local pos="$2"

	xclip -selection clipboard <<< "${buf:$pos}"
	buf="${buf:0:$pos}"

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_x_yank() {
	local buf="$1"
	local pos="$2"

	buf="${buf:0:$pos}$(xclip -selection clipboard -o)${buf:$pos}"

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_x_paste() {
	local buf="$1"
	local pos="$2"

	buf="$(xclip -selection clipboard -o &>/dev/null)"

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

# @description Print the help text for the currently-edited command on the
# readline-buffer. It reads aliases and checks for docker, style
# help page systems. This assumes that any errors with 'man'
# are due to not finding man pages (exit code 16)
_readline_util_show_help() {
	# shellcheck disable=SC1007
	local line= cmd=

	_readline_util_get_line "$1"
	_readline_util_expand_alias "$REPLY"
	line="$REPLY"

	# check if builtin from the getgo
	_readline_util_get_cmd "$line"
	cmd="$REPLY"
	if [ "$(type -t "$cmd")" = 'builtin' ]; then
		help "$cmd"
		return
	fi

	local -a argList=() flagList=()
	for arg in $line; do
		case "$arg" in
			-*) flagList+=("$arg") ;;
			*) argList+=("$arg") ;;
		esac
	done

	# For the command line (with flags removed), append help
	# If a help menu was successfuly shown, return; if not, then
	# chop off a subcommand and try again
	for ((i=0; i<${#argList}; i++)); do
		_readline_util_try_show_help "${argList[*]}" && return

		unset 'argList[${#argList[@]}-1]'
	done
}

# TODO: not POSIX (move this and others somewhere else or skip execution if not in Bash, Ksh, Zsh, etc.)

# Get the man page for the currently-edited command on the
# readline-buffer. It reads aliases and checks for docker, git
# style man page patterns. This assumes that any errors with
# 'man' are due to not finding man pages (exit code 16)
_readline_util_show_man() {
	# shellcheck disable=SC1007
	local line= manual=

	_readline_util_get_line "$1"
	_readline_util_expand_alias "$REPLY"
	line="$REPLY"

	local -a argList=()
	for arg in $line; do
		case "$arg" in
			-*) ;;
			*) argList+=("$arg") ;;
		esac
	done

	# For the command line (with flags removed and spaces converted to
	# hyphens), invoke the command command. If a man page was successfully
	# shown, return; if not, then chop off a subcommand and try again
	local oldIFS="$IFS"
	IFS='-'
	for ((i=0; i<${#argList}; i++)); do
		if _readline_util_try_show_man "${argList[*]}"; then
			IFS="$oldIFS"
			return
		fi

		unset 'argList[${#argList[@]}-1]'
	done
	IFS="$oldIFS"

	manual="${line%%-*}"
	if _readline_util_try_show_man "$manual"; then
		IFS="$oldIFS"
		return
	fi
	IFS="$oldIFS"
}

_readline_util_show_tldr() {
	local line cmd

	_readline_util_get_line "$1"
	_readline_util_expand_alias "$REPLY"
	line="$REPLY"
	_readline_util_get_cmd "$line"
	cmd="$REPLY"
	[ -z "$cmd" ] && return

	tldr "$cmd"
}

_readline_util_toggle_sudo() {
	local buf="$1"
	local pos="$2"

	if [ "${buf:0:4}" = 'sudo' ]; then
		buf="${buf:5}"
		pos=$((pos-5))
	elif [ "${buf:0:5}" = ' sudo' ]; then
		buf=" ${buf:6}"
		pos=$((pos-5))
	elif [ "${buf:0:1}" = ' ' ]; then
		buf=" sudo$buf"
		pos=$((pos+5))
	else
		buf="sudo $buf"
		pos=$((pos+5))
	fi

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_toggle_backslash() {
	local buf="$1"
	local pos="$2"

	if [ "${buf:0:1}" = "\\" ]; then
		buf="${buf:1}"
		pos=$((pos-1))
	else
		buf="\\$buf"
		pos=$((pos+1))
	fi

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_toggle_comment() {
	local buf="$1"
	local pos="$2"

	if [ "${buf:0:1}" = "#" ]; then
		buf="${buf:1}"
		pos=$((pos-1))
	else
		buf="#$buf"
		pos=$((pos+1))
	fi

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_trim_whitespace() {
	local string="$1"

	string="${string#"${string%%[![:space:]]*}"}"
	string="${string%"${string##*[![:space:]]}"}"

	REPLY="$string"
}
