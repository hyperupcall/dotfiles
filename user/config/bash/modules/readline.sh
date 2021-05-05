# shellcheck shell=bash

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

_readline_util_get_cmd() {
	local line cmd

	line="$(_readline_util_get_line "$1")"

	cmd="${line%%\ *}"

	printf "%s" "$cmd"
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
	if command man "$manual" 2>/dev/null; then
		return
	else
		(($? != 16)) && : # unhandled error
	fi

	# $ git status -v                    -> man git-status
	# $ git -v -C path                   -> man git--v
	# $ qemu-system-x86_64 -m 2048 -k en -> man qemu-system-x86_64--m
	tempLine="${line/ /-}"
	manual="${tempLine%% *}"
	if command man "$manual" 2>/dev/null; then
		return
	else
		(($? != 16)) && : # unhandled error
	fi

	# $ git -v -C path -> man git
	# $ qemu-system-x86_64 -m 2048 -k en -> man qemu-system-x86_64
	manual="${line%% *}"
	if command man "$manual" 2>/dev/null; then
		return
	else
		(($? != 16)) && : # unhandled error
	fi

	# $ qemu-system-x86_64 -m 2048 -k en -> man qemu
	manual="${line%%-*}"
	if command man "$manual" 2>/dev/null; then
		return
	else
		(($? != 16)) && : # unhandled error
	fi
}

_readline_util_trim_whitespace() {
	command sed \
		-e 's/^[[:space:]]*//' \
		-e 's/[[:space:]]*$//' \
		<<< "$1"
}

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
	local cmd
	line="$(_readline_util_expand_alias "$READLINE_LINE")"
	cmd="$(_readline_util_get_cmd "$line")"
	[[ -z $cmd ]] && return

	if [[ $(type -t "$cmd") = 'builtin' ]]; then
		help "$cmd"
	elif command -v "$cmd" &>/dev/null; then
		if "$cmd" --help &>/dev/null; then
			"$cmd" --help
		else
			"$cmd" -h
		fi
	fi
}

_readline_show_man() {
	local manual
	_readline_util_show_man "$READLINE_LINE"
}

_readline_show_tldr() {
	local cmd
	line="$(_readline_util_expand_alias "$READLINE_LINE")"
	cmd="$(_readline_util_get_cmd "$line")"
	[[ -z $cmd ]] && return

	tldr "$cmd"
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

bind '"\e;": redraw-current-line'

bind -x '"\eu": _readline_x_discard'
bind -x '"\ek": _readline_x_kill'
bind -x '"\ey": _readline_x_yank'
bind -x '"\eo": _readline_x_paste'
bind -x '"\eh": _readline_show_help'
bind -x '"\en": _readline_show_tldr'
bind -x '"\em": _readline_show_man'
bind -x '"\es": _readline_toggle_sudo'
bind -x '"\e\\": _readline_toggle_backslash'
bind -x '"\e/": _readline_toggle_comment'
bind -x '"\C-_": _readline_toggle_comment'
bind -x '"\ei": _readline_trim_whitespace'
