#!/usr/bin/env bash

# -------------------- Shell Variables ------------------- #
#CDPATH=":~:"
HISTCONTROL="ignorespace:ignoredups"
HISTFILE="$HOME/.history/bash_history"
HISTSIZE=32768
HISTFILESIZE="$HISTSIZE"
HISTIGNORE="ls:[bf]g:pwd:clear*:exit*"
HISTTIMEFORMAT="%B %m %Y %T | "
HISTTIMEFORMAT='%F %T ' # ISO 8601
unset MAILCHECK
PROMPT_DIRTRIM=5


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

# shell-installer
for file in "$XDG_DATA_HOME/shell-installer/completions/"*.{sh,bash}; do
	if [ -r "$file" ]; then
	        source "$file"
        fi
done

# --------------------- Miscellaneous -------------------- #
# bash-it
export BASH_IT="$XDG_DATA_HOME/bash-it"
export BASH_IT_THEME="powerline-multiline"
export GIT_HOSTING='git@github.com'
export IRC_CLIENT='irssi'
export SCM_CHECK=true
# shellcheck source=/dev/null
false && [ -r "$BASH_IT/bash_it.sh" ] && source "$BASH_IT/bash_it.sh"

# dircolors
[ -r "$XDG_CONFIG_HOME/dircolors/dir_colors" ] && eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# bashmarks
# shellcheck disable=SC2034
SDIRS="$XDG_DATA_HOME/bashmarks.sh.db"
source ~/.local/bin/bashmarks.sh


# ----------------------- Readline ----------------------- #
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
	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$(xclip -o)${READLINE_LINE:$READLINE_POINT}"
}

_readline-show-help() {
	_cmd="${READLINE_LINE/\ */}"
	if [[ $(type -t "$_cmd") = 'builtin' ]]; then
		help "$_cmd"
	elif command -v "$_cmd" >/dev/null 2>&1; then
		"$_cmd" --help || "$_cmd" -h
	fi
	unset -v _cmd
}

_readline-show-man() {
	_cmd="${READLINE_LINE/\ */}"
	if command -v "$_cmd" >/dev/null 2>&1; then
		man "$_cmd"
	fi
	unset -v _cmd
}

_readline-trim-whitespace() {
	READLINE_LINE="$(
		sed \
			-e 's/^[[:space:]]*//' \
			-e 's/[[:space:]]*$//' \
			<<< "$READLINE_LINE"
	)"
}

bind -x '"\eu": _readline-x-discard'
bind -x '"\ek": _readline-x-kill'
bind -x '"\ey": _readline-x-yank'
bind -x '"\eh": _readline-show-help'
bind -x '"\em": _readline-show-man'
bind -x '"\ei": _readline-trim-whitespace'
