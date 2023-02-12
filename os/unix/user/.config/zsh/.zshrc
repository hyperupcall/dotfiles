#
# ~/.zshrc
#

# Ensure execution returns if zsh is non-interactive
[[ $- != *i* ]] && [ ! -t 0 ] && return

# Ensure /etc/zprofile is read for non-login shells
# Zsh only reads /etc/zprofile on interactive, login shells
# ! shopt -q login_shell && [ -r /etc/profile ] && source /etc/profile

# Ensure ~/.zprofile is read for non-login shells
# Zsh only reads ~/.zprofile on login shells
[ -r "$ZDOTDIR/.zprofile" ] && source "$ZDOTDIR/.zprofile"


#
# ─── FRAMEWORKS ─────────────────────────────────────────────────────────────────
#

# source "$ZDOTDIR/frameworks/zinit.zsh"
# source "$ZDOTDIR/frameworks/zplug.zsh"


#
# ─── SHELL VARIABLES ────────────────────────────────────────────────────────────
#
export HISTFILE="$XDG_STATE_HOME/history/zsh_history"


#
# ─── SHELL OPTIONS ──────────────────────────────────────────────────────────────
#

# ------------------------ setopt ------------------------ #
setopt auto_cd
unsetopt auto_pushd
unsetopt cdable_vars
unsetopt cd_silent
setopt chase_dots
setopt chase_links
setopt pushd_ignore_dups
unsetopt pushd_silent

setopt auto_list
setopt auto_name_dirs
setopt auto_param_slash
setopt auto_remove_slash
setopt complete_aliases
unsetopt glob_complete
setopt list_beep
unsetopt list_packed
setopt list_types

setopt extended_glob
setopt glob_dots
setopt glob_star_short
setopt numeric_glob_sort

setopt append_history
setopt bang_hist
setopt extended_history
setopt hist_allow_clobber
unsetopt hist_beep
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
unsetopt inc_append_history
setopt share_history

unsetopt dvorak
unsetopt flow_control
setopt interactive_comments
setopt mail_warning
unset print_exit_value
setopt rc_quotes
setopt rm_star_silent
setopt rm_star_wait

setopt auto_continue
unsetopt bg_nice
setopt long_list_jobs

setopt prompt_subst

unset multios

setopt bash_rematch
setopt posix_aliases

unsetopt beep


#
# ─── PS1 ────────────────────────────────────────────────────────────────────────
#

is8Colors() {
	colors=$(tput colors 2>/dev/null)

	[ -n "$colors" ] && [ "$colors" -eq 8 ]
}

is256Colors() {
	colors=$(tput colors 2>/dev/null)

	[ -n "$colors" ] && [ "$colors" -eq 256 ]
}

is16MillionColors() {
	[ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]
}

source "$XDG_STATE_HOME/dotshellgen/concatenated.zsh"
source "$XDG_CONFIG_HOME"/zsh/modules/primary.zsh

# if is16MillionColors; then
# 	if ((EUID == 0)); then
# 		PS1="%F{#c92a2a}[%n@%M %~]$%f "
# 	else
# 		PS1="%{$fg[red]%}[%n@%M %~]$%{$reset_color%} "
# 		if ! eval "$(
# 			if ! defaultmgr launch shell-prompt-zsh; then
# 				# Without this, the error doesn't propagate to the "if ! eval ..."
# 				printf '%s\n' 'false'
# 			fi
# 		)"; then
# 			PS1="[%{$fg[red]%}(PS1 Error)%{$reset_color%} %n@%M %~]\$ "
# 		fi
# 	fi
# elif is8Colors || is256Colors; then
# 	if ((EUID == 0)); then
# 		PS1="%{$fg[red]%}[%n@%M %~]$%{$reset_color%} "
# 	else
# 		PS1="%{$fg[yellow]%}[%n@%M %~]$%{$reset_color%} "
# 	fi
# else
# 	PS1="[%n@%M %~]$ "
# fi

# unset -f is8Colors is256Colors is16MillionColors


#
# ─── MODULES ────────────────────────────────────────────────────────────────────
#

# for f in "$XDG_CONFIG_HOME"/zsh/modules/?*.zsh; do
# 	source "$f"
# done
# unset -v f

# ---
