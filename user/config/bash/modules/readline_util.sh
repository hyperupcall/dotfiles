# shellcheck shell=bash

# gets line ($1), and removes
# sudo, ', ", and extra whitespaces
_readline_util_get_line() {
	local line="$1"

	_readline_util_trim_whitespace "$line"
	line="$REPLY"

	if [[ ${line:0:4} == "sudo" ]]; then
		line="${line:4}"
	fi

	_readline_util_trim_whitespace "$line"
	line="$REPLY"

	line="${line/\\/}"
	line="${line/\'/}"
	line="${line/\'/}"
	line="${line/\"/}"
	line="${line/\"/}"

	printf "%s" "$line"
}

_readline_util_expand_alias() {
	local line="$1"

	_readline_util_trim_whitespace "${line#* }"
	local line2="$REPLY"

	if alias "${line%% *}" &>/dev/null; then
		line="$(
			alias "${line%% *}" | cut -d= -f2 | sed -e "s/^'*//" -e "s/'*$//"
		) $line2"
	fi

	printf "%s" "$line"
}

_readline_util_get_cmd() {
	local line cmd

	line="$(_readline_util_get_line "$1")"

	cmd="${line%%\ *}"

	printf "%s" "$cmd"
}

# shellcheck disable=SC2181
_readline_util_try_show_help() {
	local line cmd helpText
	line="$1"
	cmd="$(_readline_util_get_cmd "$line")"

	if ! helpText="$($line --help)"; then
		if ! helpText="$($line -h)"; then
			if ! helpText="$($line help)"; then
				return 1
			fi
		fi
	fi

	printf '%s\n' "$helpText"
	return 0
}

_readline_util_try_show_man() {
	local manual="$1"

	if command man "$manual" 2>/dev/null; then
		return
	else
		(($? != 16)) && {
			log_error "'man' invocation error"

			# By returning success, no more man pages will be searched
			return 0
		}
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
	local line cmd tempLine

	line="$(_readline_util_get_line "$1")"
	line="$(_readline_util_expand_alias "$line")"

	# check if built in from the getgo
	cmd="$(_readline_util_get_cmd "$line")"
	if [[ $(type -t "$cmd") = 'builtin' ]]; then
		help "$cmd"
		return
	fi

	# docker container ls -l   -> docker container ls --help
	tempLine="${line/ /^}"
	tempLine="${tempLine/ /^}"
	tempLine="${tempLine%% *}"
	tempLine="${tempLine/^/ }"
	tempLine="${tempLine/^/ }"
	_readline_util_try_show_help "$tempLine" && return

	# docker container         -> docker container --help
	tempLine="${line/ /^}"
	tempLine="${tempLine%% *}"
	tempLine="${tempLine/^/ }"
	_readline_util_try_show_help "$tempLine" && return

	# docker version           -> docker --help
	tempLine="${line%% *}"
	_readline_util_try_show_help "$tempLine" && return
}

# Get the man page for the currently-edited command on the
# readline-buffer. It reads aliases and checks for docker, git
# style man page patterns. This assumes that any errors with
# 'man' are due to not finding man pages (exit code 16)
_readline_util_show_man() {
	local line tempLine manual

	line="$(_readline_util_get_line "$1")"
	line="$(_readline_util_expand_alias "$line")"

	# $ docker container ls -v           -> man docker-container-ls
	# $ git status -v                    -> man git-status--v
	# $ git -v -C path                   -> man git--v--C
	# $ qemu-system-x86_64 -m 2048 -k en -> man qemu-system-x86_64--m-2048
	tempLine="${line/ /-}"
	tempLine="${tempLine/ /-}"
	manual="${tempLine%% *}"
	_readline_util_try_show_man "$manual" && return

	# $ git status -v                    -> man git-status
	# $ git -v -C path                   -> man git--v
	# $ qemu-system-x86_64 -m 2048 -k en -> man qemu-system-x86_64--m
	tempLine="${line/ /-}"
	manual="${tempLine%% *}"
	_readline_util_try_show_man "$manual" && return

	# $ git -v -C path -> man git
	# $ qemu-system-x86_64 -m 2048 -k en -> man qemu-system-x86_64
	manual="${line%% *}"
	_readline_util_try_show_man "$manual" && return

	# $ qemu-system-x86_64 -m 2048 -k en -> man qemu
	manual="${line%%-*}"
	_readline_util_try_show_man "$manual" && return
}

_readline_util_show_tldr() {
	local line cmd

	line="$(_readline_util_get_line "$1")"
	line="$(_readline_util_expand_alias "$line")"
	cmd="$(_readline_util_get_cmd "$line")"
	[[ -z $cmd ]] && return

	tldr "$cmd"
}

_readline_util_toggle_sudo() {
	local buf="$1"
	local pos="$2"

	if [[ ${buf:0:4} == 'sudo' ]]; then
		buf="${buf:5}"
		pos="$((pos-5))"
	elif [[ ${buf:0:5} == ' sudo' ]]; then
		buf=" ${buf:6}"
		pos="$((pos-5))"
	elif [[ ${buf:0:1} == ' ' ]]; then
		buf=" sudo$buf"
		pos="$((pos+5))"
	else
		buf="sudo $buf"
		pos="$((pos+5))"
	fi

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_toggle_backslash() {
	local buf="$1"
	local pos="$2"

	if [[ ${buf:0:1} == "\\" ]]; then
		buf="${buf:1}"
		pos="$((pos-1))"
	else
		buf="\\$buf"
		pos="$((pos+1))"
	fi

	# shellcheck disable=SC2034
	REPLY1="$buf"
	# shellcheck disable=SC2034
	REPLY2="$pos"
}

_readline_util_toggle_comment() {
	local buf="$1"
	local pos="$2"

	if [[ ${buf:0:1} == "#" ]]; then
		buf="${buf:1}"
		pos="$((pos-1))"
	else
		buf="#$buf"
		pos="$((pos+1))"
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
