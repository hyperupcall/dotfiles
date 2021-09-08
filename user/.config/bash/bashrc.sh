# shellcheck shell=bash
#
# ~/.bashrc
#

# ensure execution returns if bash is non-interactive
[[ $- != *i* ]] && [ ! -t 0 ] && return

# ensure /etc/profile is read for non-login shells
# bash only reads /etc/profile on interactive, login shells
! shopt -q login_shell && [ -r /etc/profile ] && source /etc/profile

# ensure ~/.profile is read for non-login shells
# bash only reads ~/.profile on login shells when invoked as sh
[ -r ~/.profile ] && source ~/.profile

#
# ─── FRAMEWORKS ─────────────────────────────────────────────────────────────────
#

# source_safe "$XDG_CONFIG_HOME/bash/frameworks/oh-my-bash.sh"
# source_safe "$XDG_CONFIG_HOME/bash/frameworks/bash-it.sh"


#
# ─── SHELL VARIABLES ────────────────────────────────────────────────────────────
#

# exported so nested shells, virtual environments, etc. inherit the new values

# export CDPATH=":~:"
# export CHILD_MAX="256"
unset EXECIGNORE
export FCEDIT="$EDITOR"
unset FIGNORE
unset GLOBIGNORE
export HISTCONTROL="ignorespace:ignoredups"
export HISTFILE="$XDG_STATE_HOME/history/bash_history"
export HISTSIZE="-1"
export HISTFILESIZE="-1"
export HISTIGNORE="ls:[bf]g:pwd:clear*:exit*:*sudo*-S*:*sudo*--stdin*"
export HISTTIMEFORMAT="%B %m %Y %T | "
export HISTTIMEFORMAT='%F %T ' # ISO 8601
export TIMEFORMAT=$'real    %3lR\nuser    %3lU\nsystem  %3lS\npercent %P'
export PROMPT_DIRTRIM="6"
unset MAIL
unset MAILCHECK
unset MAILPATH

#
# ─── SHELL OPTIONS ──────────────────────────────────────────────────────────────
#

# ------------------------- shopt ------------------------ #
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -u hostcomplete
shopt -s interactive_comments
shopt -u mailwarn
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -u nullglob # setting obtains unexpected parameter expansion behavior
shopt -s progcomp
((${BASH_VERSION[0]%%.*} == 5)) && shopt -s progcomp_alias # not working due to complete -D
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo

# -------------------------- set ------------------------- #
set -o noclobber
set -o notify
set -o physical


#
# ─── PS1 ────────────────────────────────────────────────────────────────────────
#

is8Colors() {
	colors="$(tput colors 2>/dev/null)"

	[ -n "$colors" ] && [ "$colors" -eq 8 ]
}

is256Colors() {
	colors="$(tput colors 2>/dev/null)"

	[ -n "$colors" ] && [ "$colors" -eq 256 ]
}

is16MillionColors() {
	[ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]
}

source_safe "$XDG_CONFIG_HOME/shell/generated/aggregated.bash"

if is16MillionColors; then
	if ((EUID == 0)); then
		PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]\$ "
	else
		# shellcheck disable=SC3046
		if ! eval "$(
			if ! choose launch shell-prompt-bash; then
				# Without this, the error doesn't propagate to
				# the "if ! eval ..."
				printf '%s\n' 'false'
			fi
		)"; then
			PS1="[\[\e[0;31m\](PS1 Error)\[\e[0m\] \u@\h \w]\$ "
		fi
	fi
elif is8Colors || is256Colors; then
	if ((EUID == 0)); then
		PS1="\[\e[0;31m\][\u@\h \w]\[\e[0m\]\$ "
	else
		PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]\$ "
	fi
else
	PS1="[\u@\h \w]\$ "
fi

unset -f is8Colors is256Colors is16MillionColors

#
# ─── MISCELLANEOUS ──────────────────────────────────────────────────────────────
#

# bash_completion (also sources $XDG_CONFIG_HOME/bash/bash_completions (as per env variable))
# even though we `source /etc/profile` at beginnning of script, this is still needed since we now
# only have BASH_COMPLETION_USER_DIR and BASH_COMPLETION_USER_FILE set
[ -r /usr/share/bash-completion/bash_completion ] && source_safe /usr/share/bash-completion/bash_completion

# bash-preexec
if command -v basalt &>/dev/null; then
	basalt-load -g 'rcaloras/bash-preexec' 'bash-preexec.sh'

	# after command is read, before command execution
	preexec() {
		:
	}

	# before each prompt
	precmd() {
		# for cdp()
		# shellcheck disable=SC2034
		_shell_cdp_dir="$PWD"
	}
fi

source_safe "$XDG_CONFIG_HOME/shell/modules/line-editing.sh"
source_safe "$XDG_CONFIG_HOME/bash/modules/readline.sh"
source_safe "$XDG_CONFIG_HOME/bash/modules/util.sh"


# -----
