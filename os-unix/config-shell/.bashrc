# shellcheck shell=bash
# Stop execution if bash is non-interactive.
[[ $- != *i* ]] && [ ! -t 0 ] && return

# Ensure /etc/profile is read for non-login shells.
# Bash only reads /etc/profile on interactive, login shells.
# ! shopt -q login_shell && [ -f /etc/profile ] && source /etc/profile

# Ensure ~/.profile is read for non-login shells
# Bash only reads ~/.profile on login shells when invoked as sh
[ -f ~/.profile ] && source ~/.profile
(( $? != 0 )) && _util_print_source_error '~/.profile'

# Use frameworks.
# source "$XDG_CONFIG_HOME/bash/frameworks/oh-my-bash.sh"
# source "$XDG_CONFIG_HOME/bash/frameworks/bash-it.sh"

# Set shell variables.
# Exported variables are inherited in nested shells and virtual environments.
# export CDPATH=':~:'
# export CHILD_MAX='256'
unset -v EXECIGNORE
export FCEDIT="$EDITOR"
unset -v FIGNORE
unset -v GLOBIGNORE
export HISTCONTROL='ignorespace:ignoredups'
export HISTFILE="$XDG_STATE_HOME/history/bash_history"
export HISTSIZE='-1'
export HISTFILESIZE='-1'
export HISTIGNORE='ls:dir|vdir|[bf]g:pwd:clear*:exit*:mkcd*:mkt*'
export HISTTIMEFORMAT='%F %T ' # ISO 8601
export TIMEFORMAT=$'real    %3lR\nuser    %3lU\nsystem  %3lS\npercent %P'
export PROMPT_DIRTRIM='6'
unset -v MAIL
unset -v MAILCHECK
unset -v MAILPATH

# Set bash options.
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -u direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globasciiranges
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
shopt -u nullglob # Setting obtains unexpected parameter expansion behavior.
shopt -s progcomp
((BASH_VERSINFO[0] == 5)) && shopt -s progcomp_alias
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo

# PS1.
if [ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]; then
	if ((EUID == 0)); then
		PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]\$ "
	else
		PS1="[\u@\h \w]\$ "
		# shellcheck disable=SC3046
		if ! eval "$(
			if ! starship init bash; then # TODO: default
				printf '%s\n' 'false' # Propagate error.
			fi
		)"; then
			PS1="[\[\e[0;31m\](PS1 Error)\[\e[0m\] \u@\h \w]\$ "
		fi
	fi
else
	_colors=$(tput colors 2>/dev/null)
	if [ -n "$_colors" ] && (( _colors == 8 || _colors == 256)); then
		if ((EUID == 0)); then
			PS1="\[\e[0;31m\][\u@\h \w]\[\e[0m\]\$ "
		else
			PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]\$ "
		fi
	else
		PS1="[\u@\h \w]\$ "
	fi
	unset -v _colors
fi

# Modules.
_util_source_dir "$XDG_CONFIG_HOME/bash/modules"
_util_source_dir "$XDG_CONFIG_HOME/bash/bash.d"

# ---
