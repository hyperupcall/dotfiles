# shellcheck shell=bash

_readline_util_get_cmd() {
	local line cmd

	line="$READLINE_LINE"
	line="$(_readline_util_trim_whitespace "$line")"
	cmd="${line/\ */}"

	if [[ $cmd == 'sudo' ]]; then
		line="${line/sudo/}"
		line="$(_readline_util_trim_whitespace "$line")"
		cmd="${line/\ */}"
	fi

	cmd="${cmd/\\/}"
	cmd="${cmd/\'/}"
	cmd="${cmd/\'/}"
	cmd="${cmd/\"/}"
	cmd="${cmd/\"/}"

	printf "%s" "$cmd"
}

_readline_util_trim_whitespace() {
	'sed' \
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
	cmd="$(_readline_util_get_cmd)"
	if [[ $(type -t "$cmd") = 'builtin' ]]; then
		help "$cmd"
	elif command -v "$cmd" &>/dev/null; then
		"$cmd" --help || "$cmd" -h
	fi
}

_readline_show_man() {
	local cmd
	cmd="$(_readline_util_get_cmd)"
	'man' "$cmd"
	(($? == 16)) && [[ $cmd != "${cmd%%-*}" ]] && 'man' "${cmd%%-*}" # qemu
}

_readline_toggle_sudo() {
	if [[ ${READLINE_LINE:0:4} == 'sudo' ]]; then
		READLINE_LINE="${READLINE_LINE:5}"
	elif [[ ${READLINE_LINE:0:5} == ' sudo' ]]; then
		READLINE_LINE=" ${READLINE_LINE:6}"
	elif [[ ${READLINE_LINE:0:1} == ' ' ]]; then
		READLINE_LINE=" sudo$READLINE_LINE"
		[[ ${#READLINE_LINE} -eq 6 ]] && READLINE_POINT=6
	else
		READLINE_LINE="sudo $READLINE_LINE"
		[[ ${#READLINE_LINE} -eq 5 ]] && READLINE_POINT=5
	fi
}

_readline_toggle_backslash() {
	if [[ ${READLINE_LINE:0:1} == "\\" ]]; then
		READLINE_LINE="${READLINE_LINE:1}"
	else
		READLINE_LINE="\\$READLINE_LINE"
	fi
}

_readline_toggle_comment() {
	if [[ ${READLINE_LINE:0:1} == "#" ]]; then
		READLINE_LINE="${READLINE_LINE:1}"
	else
		READLINE_LINE="#$READLINE_LINE"
	fi
}

_readline_trim_whitespace() {
	READLINE_LINE="$(
		_readline_util_trim_whitespace "$READLINE_LINE"
	)"
}

bind -x '"\eu": _readline_x_discard'
bind -x '"\ek": _readline_x_kill'
bind -x '"\ey": _readline_x_yank'
bind -x '"\eo": _readline_x_paste'
bind -x '"\eh": _readline_show_help'
bind -x '"\em": _readline_show_man'
bind -x '"\es": _readline_toggle_sudo'
bind -x '"\e\\": _readline_toggle_backslash'
bind -x '"\e/": _readline_toggle_comment'
bind -x '"\C-_": _readline_toggle_comment'
bind -x '"\ei": _readline_trim_whitespace'
