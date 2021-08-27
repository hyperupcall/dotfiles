# shellcheck shell=bash

_readline_x_discard() {
	_readline_util_x_discard "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE="$REPLY1"
	READLINE_POINT="$REPLY2"
}

_readline_x_kill() {
	_readline_util_x_kill "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE="$REPLY1"
	READLINE_POINT="$REPLY2"
}

_readline_x_yank() {
	_readline_util_x_yank "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE="$REPLY1"
	READLINE_POINT="$REPLY2"
}

_readline_x_paste() {
	_readline_util_x_paste "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE="$REPLY1"
	READLINE_POINT="$REPLY2"
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
	_readline_util_toggle_sudo "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE="$REPLY1"
	READLINE_POINT="$REPLY2"
}

_readline_toggle_backslash() {
	_readline_util_toggle_backslash "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE="$REPLY1"
	READLINE_POINT="$REPLY2"
}

_readline_toggle_comment() {
	_readline_util_toggle_comment "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE="$REPLY1"
	READLINE_POINT="$REPLY2"
}

_readline_trim_whitespace() {
	_readline_util_trim_whitespace "$READLINE_LINE"
	READLINE_LINE="$REPLY"
}

_readline_ls() {
	_shell_util_ls
}

bind -x '"\eu": _readline_x_discard'
bind -x '"\ek": _readline_x_kill'
bind -x '"\ey": _readline_x_yank'
bind -x '"\eo": _readline_x_paste'
bind -x '"\eh": _readline_show_help'
bind -x '"\em": _readline_show_man'
# bind -x '"\et": _readline_show_tldr'
bind -x '"\es": _readline_toggle_sudo'
bind -x '"\e\\": _readline_toggle_backslash'
bind -x '"\e/": _readline_toggle_comment'
bind -x '"\C-_": _readline_toggle_comment'
bind -x '"\ei": _readline_trim_whitespace'
bind -x '"\el": _readline_ls'
