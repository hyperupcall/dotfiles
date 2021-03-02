#!/usr/bin/env bash

# -------------------- Shell Variables ------------------- #
#CDPATH=":~:"
HISTCONTROL="ignorespace:ignoredups"
HISTFILE="$HOME/.history/bash_history"
HISTSIZE=32768
HISTFILESIZE="$HISTSIZE"
# non-numeric means no truncation
#HISTFILESIZE="_"
HISTIGNORE="ls:[bf]g:pwd:clear*:exit*"
HISTTIMEFORMAT="%B %m %Y %T | "
HISTTIMEFORMAT='%F %T ' # ISO 8601
unset MAILCHECK
PROMPT_DIRTRIM=5


# ---------------------- Frameworks ---------------------- #
#source "$XDG_CONFIG_HOME/bash/oh-my-bash.sh"
#source "$XDG_CONFIG_HOME/bash/bash-it.sh"

# --------------------- Shell Options -------------------- #
# shopt
shopt -s autocd
shopt -u cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize # default
shopt -s cmdhist # default
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -u hostcomplete
shopt -s interactive_comments # default
shopt -u mailwarn
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -u nullglob # setting obtains unexpected parameter expansion behavior
shopt -s progcomp
((${BASH_VERSION%%.*} == 5)) && shopt -s progcomp_alias # not working due to complete -D
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo # default

# set
set -o noclobber
set -o notify # deafult
set -o physical # default


# -------------------------- PS1 ------------------------- #
8BitColor() {
	test "$(tput colors)" -eq 8
}

24BitColor() {
	test "$COLORTERM" = "truecolor" || test "$COLORTERM" = "24bit"
}

if 24BitColor; then
	if test "$EUID" = 0; then
		PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]\$ "
	else
		source ~/repos/fox-default/fox-default.sh launch bash-prompt \
			|| PS1="[PS1 Error: \u@\h \w]\$ "
	fi
elif 8BitColor; then
	if test "$EUID" = 0; then
		PS1="\[\e[0;31m\][\u@\h \w]\[\e[0m\]\$ "
	else
		PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]\$ "
	fi
else
	PS1="[\u@\h \w]\$ "
fi

unset -f 8BitColor
unset -f 24BitColor


# ---------------------- Completions --------------------- #
# system
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# asdf
source "$XDG_DATA_HOME/asdf/completions/asdf.bash"

# dot.sh
source "$HOME/scripts/dot/completion/dot.bash"

# shell-installer
for file in "$XDG_DATA_HOME/shell-installer/completions/"*.{sh,bash}; do
	if [ -r "$file" ]; then
		source "$file"
	fi
done

# --------------------- Miscellaneous -------------------- #
# dircolors
[ -r "$XDG_CONFIG_HOME/dircolors/dir_colors" ] && eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# direnv
eval "$(direnv hook bash)"

# bashmarks
# shellcheck disable=SC2034
SDIRS="$XDG_DATA_HOME/bashmarks.sh.db"
source ~/.local/bin/bashmarks.sh

# nvidia-settings
#if command -v nvidia-settings > /dev/null 2>&1; then
#    nvidia-settings --load-config-only &
#fi

# ----------------------- Readline ----------------------- #
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

	# TODO: fix
	cmd="${cmd/\/}"
	cmd="${cmd/\'/}"
	cmd="${cmd/\"/}"
	printf "%s" "$cmd"
}

_readline_util_trim_whitespace() {
	sed \
		-e 's/^[[:space:]]*//' \
		-e 's/[[:space:]]*$//' \
		<<< "$1"
}

_readline-x-discard() {
	echo -n "${READLINE_LINE:0:$READLINE_POINT}" | xclip -selection clipboard
	READLINE_LINE="${READLINE_LINE:$READLINE_POINT}"
	READLINE_POINT=0
}

_readline-x-kill() {
	echo -n "${READLINE_LINE:$READLINE_POINT}" | xclip -selection clipboard
	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}"
}

_readline-x-yank() {
	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$(xclip -selection clipboard -o)${READLINE_LINE:$READLINE_POINT}"
}

_readline-x-paste() {
	READLINE_LINE="$(printf "%s" "$(xclip -selection clipboard -o &>/dev/null)")"
}


_readline-show-help() {
	local cmd
	cmd="$(_readline_util_get_cmd)"
	if [[ $(type -t "$cmd") = 'builtin' ]]; then
		help "$cmd"
	elif command -v "$cmd" &>/dev/null; then
		"$cmd" --help || "$cmd" -h
	else
		# TODO: sleep doesn't work as expected
		# local -r old_readline_line="$READLINE_LINE"
		# READLINE_LINE="Not found: '$cmd'"
		# sleep 0.5
		# READLINE_LINE="$old_readline_line"
		:
	fi
}

_readline-show-man() {
	local cmd
	cmd="$(_readline_util_get_cmd)"
	if command -v "$cmd" &>/dev/null; then
		man "$cmd"
	else
		# TODO: sleep doesn't work as expected
		# local -r old_readline_line="$READLINE_LINE"
		# READLINE_LINE="Not found: '$cmd'"
		# sleep 0.5
		# READLINE_LINE="$old_readline_line"
		:
	fi
}

_readline-toggle-sudo() {
	if [[ ${READLINE_LINE:0:4} == 'sudo' ]]; then
		READLINE_LINE="${READLINE_LINE:5}"
	elif [[ ${READLINE_LINE:0:5} == ' sudo' ]]; then
		READLINE_LINE=" ${READLINE_LINE:6}"
	elif [[ ${READLINE_LINE:0:1} == ' ' ]]; then
		READLINE_LINE=" sudo$READLINE_LINE"
	else
		READLINE_LINE="sudo $READLINE_LINE"
	fi
}

_readline-trim-whitespace() {
	READLINE_LINE="$(
		_readline_util_trim_whitespace "$READLINE_LINE"
	)"
}

bind -x '"\eu": _readline-x-discard'
bind -x '"\ek": _readline-x-kill'
bind -x '"\ey": _readline-x-yank'
bind -x '"\eo": _readline-x-paste'
bind -x '"\eh": _readline-show-help'
bind -x '"\em": _readline-show-man'
bind -x '"\es": _readline-toggle-sudo'
bind -x '"\ei": _readline-trim-whitespace'
