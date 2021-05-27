# shellcheck shell=bash

# ------------------- Utility Functions ------------------ #

_readline_util_trim_whitespace() {
	command sed \
		-e 's/^[[:space:]]*//' \
		-e 's/[[:space:]]*$//' \
		<<< "$1"
}

# gets line ($1), and removes
# sudo, ', ", and extra whitespaces
_readline_util_get_line() {
	local line="$1"

	line="$(_readline_util_trim_whitespace "$line")"

	if [[ ${line:0:4} == "sudo" ]]; then
		line="${line:4}"
	fi

	line="$(_readline_util_trim_whitespace "$line")"

	line="${line/\\/}"
	line="${line/\'/}"
	line="${line/\'/}"
	line="${line/\"/}"
	line="${line/\"/}"

	printf "%s" "$line"
}

_readline_util_expand_alias() {
	line="$1"

	if alias "${line%% *}" &>/dev/null; then
		line="$(
			alias "${line%% *}" | cut -d= -f2 | sed -e "s/^'*//" -e "s/'*$//"
		) $(_readline_util_trim_whitespace "${line#* }")"
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

# Print the help text for the currently-edited command on the
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

# ------------------ Readline Functions ------------------ #

_readline_x_discard() {
	printf "%s" "${READLINE_LINE:0:$READLINE_POINT}" | xclip -selection clipboard
	READLINE_LINE="${READLINE_LINE:$READLINE_POINT}"
	READLINE_POINT=0
}

_readline_x_kill() {
	printf "%s" "${READLINE_LINE:$READLINE_POINT}" | xclip -selection clipboard
	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}"
}

_readline_x_yank() {
	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$(xclip -selection clipboard -o)${READLINE_LINE:$READLINE_POINT}"
}

_readline_x_paste() {
	READLINE_LINE="$(printf "%s" "$(xclip -selection clipboard -o &>/dev/null)")"
}

_readline_show_help() {
	_readline_util_show_help "$READLINE_LINE"
}

_readline_show_man() {
	_readline_util_show_man "$READLINE_LINE"
}

_readline_show_tldr() {
	_readline_util_show_tldr "$READLINE_LINE"
}

_readline_toggle_sudo() {
	if [[ ${READLINE_LINE:0:4} == 'sudo' ]]; then
		READLINE_LINE="${READLINE_LINE:5}"
		READLINE_POINT="$((READLINE_POINT-5))"
	elif [[ ${READLINE_LINE:0:5} == ' sudo' ]]; then
		READLINE_LINE=" ${READLINE_LINE:6}"
		READLINE_POINT="$((READLINE_POINT-5))"
	elif [[ ${READLINE_LINE:0:1} == ' ' ]]; then
		READLINE_LINE=" sudo$READLINE_LINE"
		READLINE_POINT="$((READLINE_POINT+5))"
	else
		READLINE_LINE="sudo $READLINE_LINE"
		READLINE_POINT="$((READLINE_POINT+5))"
	fi
}

_readline_toggle_backslash() {
	if [[ ${READLINE_LINE:0:1} == "\\" ]]; then
		READLINE_LINE="${READLINE_LINE:1}"
		READLINE_POINT="$((READLINE_POINT-1))"
	else
		READLINE_LINE="\\$READLINE_LINE"
		READLINE_POINT="$((READLINE_POINT+1))"
	fi
}

_readline_toggle_comment() {
	if [[ ${READLINE_LINE:0:1} == "#" ]]; then
		READLINE_LINE="${READLINE_LINE:1}"
		READLINE_POINT="$((READLINE_POINT-1))"
	else
		READLINE_LINE="#$READLINE_LINE"
		READLINE_POINT="$((READLINE_POINT+1))"
	fi
}

_readline_trim_whitespace() {
	READLINE_LINE="$(
		_readline_util_trim_whitespace "$READLINE_LINE"
	)"
}

_readline_ls() {
	_shell_util_ls
}

_readline_exit() {
	exit
}

bind -x '"\eu": _readline_x_discard'
bind -x '"\ek": _readline_x_kill'
bind -x '"\ey": _readline_x_yank'
bind -x '"\eo": _readline_x_paste'
bind -x '"\eh": _readline_show_help'
# bind -x '"\et": _readline_show_tldr'
bind -x '"\em": _readline_show_man'
bind -x '"\es": _readline_toggle_sudo'
bind -x '"\e\\": _readline_toggle_backslash'
bind -x '"\e/": _readline_toggle_comment'
bind -x '"\C-_": _readline_toggle_comment'
bind -x '"\ei": _readline_trim_whitespace'
bind -x '"\el": _readline_ls'
