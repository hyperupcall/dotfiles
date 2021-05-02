#
# ~/.zshrc
#

# ensure execution returns if zsh is non-interactive
[[ $- != *i* ]] && [ ! -t 0 ] && return

# TODO:
# ensure /etc/profile is read for non-login shells
# bash only reads /etc/profile on interactive, login shells
# ! shopt -q login_shell && [ -r /etc/profile ] && source /etc/profile

# TODO: check if needed for zsh
# ensure ~/.profile is read for non-login shells
# bash only reads ~/.profile on login shells when invoked as sh
[ -r "$XDG_CONFIG_HOME/zsh/.zprofile" ] && source "$XDG_CONFIG_HOME/zsh/.zprofile"


#
# ─── FRAMEWORKS ─────────────────────────────────────────────────────────────────
#

# source "$XDG_CONFIG_HOME/zsh/frameworks/oh-my-zsh.sh"


#
# ─── SHELL VARIABLES ────────────────────────────────────────────────────────────
#
HISTFILE="$HOME/.history/zsh_history"


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
unsetopt complete_aliases
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

# -------------------------- set ------------------------- #


#
# ─── PS1 ────────────────────────────────────────────────────────────────────────
#

8Colors() {
	test "$(tput colors)" -eq 8
}

256Colors() {
	test "$(tput colors)" -eq 256
}

16MillionColors() {
	test "$COLORTERM" = "truecolor" || test "$COLORTERM" = "24bit"
}

if 16MillionColors; then
	if test "$EUID" = 0; then
		PS1="$(_profile_util_print_colorhdr_root)"
	else
		# TODO: fox-default
		eval "$(starship init zsh)" || {
			PS1="$(_profile_util_print_colorhdr_error)"
		}
	fi
elif 8Colors || 256Colors; then
	if test "$EUID" = 0; then
		PS1="$(_profile_util_print_color_root)"
	else
		PS1="$(_profile_util_print_color_user)"
	fi
else
	PS1="$(_profile_util_print_bw)"
fi

unset -f 8Colors 256Colors 16MillionColors

#
# ─── MODULES ────────────────────────────────────────────────────────────────────
#

source "$XDG_CONFIG_HOME/zsh/modules/miscellaneous.zsh"
