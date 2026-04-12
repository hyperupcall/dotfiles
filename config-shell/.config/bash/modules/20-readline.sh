# shellcheck shell=bash

_readline_show_help() {
	_lineediting_action_show_help "$READLINE_LINE"
}

_readline_show_man() {
	_lineediting_action_show_man "$READLINE_LINE"
}

_readline_toggle_sudo() {
	_lineediting_action_toggle_sudo "$READLINE_LINE" "$READLINE_POINT"
	READLINE_LINE=$REPLY1
	READLINE_POINT=$REPLY2
}

_readline_trim_whitespace() {
	_lineediting_action_trim_whitespace "$READLINE_LINE"
	READLINE_LINE=$REPLY
}

_readline_ls() {
	_util_ls
}

bind -x '"\eh": _readline_show_help'
bind -x '"\em": _readline_show_man'
bind -x '"\es": _readline_toggle_sudo'
bind -x '"\ei": _readline_trim_whitespace'
bind -x '"\el": _readline_ls'
