# Stop execution if Zsh is non-interactive.
[[ $- != *i* ]] && [ ! -t 0 ] && return

# Ensure /etc/zprofile is read for non-login shells.
# Zsh only reads /etc/zprofile on interactive, login shells.
# ! shopt -q login_shell && [ -f /etc/profile ] && source /etc/profile

# Ensure ~/.zprofile is read for non-login shells
# Zsh only reads ~/.zprofile on login shells
[ -f "${ZDOTDIR:-"$HOME"}/.zprofile" ] && source "${ZDOTDIR:-"$HOME"}/.zprofile"
(( $? != 0 )) && _util_print_source_error '~/.profile'

# TODO
ZSH_DISABLE_COMPFIX=true
fpath=(
  /usr/share/zsh/functions
  /usr/share/zsh/site-functions
  /usr/share/zsh/vendor-completions
  /usr/local/share/zsh/site-functions
  $fpath
)

# Use frameworks.
# See performance: https://github.com/romkatv/zsh-bench
# source "${ZDOTDIR:-"$HOME"}/frameworks/zinit.zsh"
# source "$ZDOTDIR/frameworks/zplug.zsh"

# Set shell variables.
# Exported variables are inherited in nested shells and virtual environments.
export HISTFILE="$XDG_STATE_HOME/history/zsh_history"

# Set Zsh options.
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
setopt inc_append_history
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

# PS1.
autoload -U colors && colors
if [ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]; then
	if ((EUID == 0)); then
		PS1="%F{#c92a2a}[%n@%M %~]$%f "
	else
		PS1="%{$fg[red]%}[%n@%M %~]$%{$reset_color%} "
		if ! eval "$(
			if ! print_shell_prompt_eval_string zsh starship; then
				printf '%s\n' 'false' # Propagate error.
			fi
		)"; then
			PS1="[%{$fg[red]%}(PS1 Error)%{$reset_color%} %n@%M %~]\$ "
		fi
	fi
else
	_colors=$(tput colors 2>/dev/null)
	if [ -n "$_colors" ] && (( _colors == 8 || _colors == 256)); then
		if ((EUID == 0)); then
			PS1="%{$fg[red]%}[%n@%M %~]$%{$reset_color%} "
		else
			PS1="%{$fg[yellow]%}[%n@%M %~]$%{$reset_color%} "
		fi
	else
		PS1="[%n@%M %~]$ "
	fi
	unset -v _colors
fi

# # zmodload zsh/compctl
# # zmodload zsh/complete
# # zmodload zsh/complist
# # zmodload zsh/computil

# # zmodload zsh/zle
# # zmodload zsh/zleparameter
# # zmodload zsh/zpty

# typeset -U PATH path


# autoload run-help
# autoload zmv
# # autoload -Uz edit-command-line run-help zmv
# # autoload -Uz add-zsh-hook

# autoload -RU colors && colors
# autoload -RUz run-help
# autoload -RUz run-help-git
# autoload -RUz run-help-svn
# autoload -RUz run-help-svk
# # autoload -RUz promptinit
# # promptinit

# # TODO
# typeset -g -A key
# key[Up]="${terminfo[kcuu1]}"
# key[Down]="${terminfo[kcud1]}"
# key[Control-Left]="${terminfo[kLFT5]}"
# key[Control-Right]="${terminfo[kRIT5]}"

# [[ -n "${key[Up]}" ]] && bindkey -- "${key[Up]}" up-line-or-beginning-search
# [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# [[ -n "${key[Control-Left]}" ]] && bindkey -- "${key[Control-Left]}" backward-word
# [[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
#
_zle_show_help() {
	_lineediting_action_show_help "$BUFFER"
}
_zle_show_man() {
	_lineediting_action_show_man "$BUFFER"
}
_zle_toggle_sudo() {
	_lineediting_action_toggle_sudo "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}
_zle_trim_whitespace() {
	BUFFER="$(
		_lineediting_action_trim_whitespace "$BUFFER"
	)"
}
_zle_ls(){
	_util_ls
}
_zle_exit() {
	exit
}

# zle -N _zle_show_help
# zle -N _zle_show_man
# zle -N _zle_toggle_sudo
# zle -N _zle_trim_whitespace
# zle -N _zle_ls
# zle -N _zle_exit

bindkey -e
# bindkey -e "\eh" _zle_show_help
# bindkey -e "\em" _zle_show_man
# bindkey -e "\es" _zle_toggle_sudo
# bindkey -e "\ei" _zle_trim_whitespace
# bindkey -e "\el" _zle_ls

# autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
# zle -N edit-command-line
# zle -N zle-line-init
# zle -N zle-keymap-select
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search


# autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search

# # [[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
# # [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# # key[Control-Left]="${terminfo[kLFT5]}"
# # key[Control-Right]="${terminfo[kRIT5]}"

# # [[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
# # [[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# # typeset -g -A key

# # key[Home]="${terminfo[khome]}"
# # key[End]="${terminfo[kend]}"
# # key[Insert]="${terminfo[kich1]}"
# # key[Backspace]="${terminfo[kbs]}"
# # key[Delete]="${terminfo[kdch1]}"
# # key[Up]="${terminfo[kcuu1]}"
# # key[Down]="${terminfo[kcud1]}"
# # key[Left]="${terminfo[kcub1]}"
# # key[Right]="${terminfo[kcuf1]}"
# # key[PageUp]="${terminfo[kpp]}"
# # key[PageDown]="${terminfo[knp]}"
# # key[Shift-Tab]="${terminfo[kcbt]}"

# # # setup key accordingly
# # [[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
# # [[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
# # [[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
# # [[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
# # [[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
# # [[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
# # [[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
# # [[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
# # [[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
# # [[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
# # [[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
# # [[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# # Finally, make sure the terminal is in application mode, when zle is
# # active. Only then are the values from $terminfo valid.
# # if [[ ${+terminfo[smkx]} && ${+terminfo[rmkx]} ]]; then
# # 	autoload -Uz add-zle-hook-widget
# # 	function zle_application_mode_start { echoti smkx }
# # 	function zle_application_mode_stop { echoti rmkx }
# # 	add-zle-hook-widget zle-line-init zle_application_mode_start
# # 	add-zle-hook-widget zle-line-finish zle_application_mode_stop
# # fi

# bindkey -M vicmd '^T' history-incremental-pattern-search-backward # Patterned history search with zsh expansion, globbing, etc.
# bindkey '^T' history-incremental-pattern-search-backward
# bindkey -e
# bindkey ' ' magic-space
# bindkey -M isearch '^M' accept-search # Verify search result before accepting
# autoload run-help
alias help='run-help'

# WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'


# SAVEHIST=2147483647
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# HISTSIZE=10000
# SAVEHIST=10000
# setopt appendhistory

# bindkey '^P' history-beginning-search-backward
# bindkey '^N' history-beginning-search-forward
# bindkey '^R' history-incremental-search-backward

# # autoload -Uz history-search-end
# # zle -N history-beginning-search-backward-end history-search-end
# # zle -N history-beginning-search-forward-end history-search-end
# # bindkey -M vicmd "^P" history-beginning-search-backward-end
# # bindkey -M viins "^P" history-beginning-search-backward-end

# # bindkey -M vicmd "^N" history-beginning-search-forward-end
# # bindkey -M viins "^N" history-beginning-search-forward-end
# zstyle ':completion:*' menu select
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' rehash yes
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle 'calendar-file' "$HOME/data/zsh/calendar"
# zstyle ':completion::complete:*' gain-privileges 1

# zstyle ':completion:*' rehash true


# Modules.
_util_source_file "$XDG_CONFIG_HOME/sh/line-editing.sh"
_util_source_dir "$XDG_CONFIG_HOME/zsh/zsh.d"

# ---
