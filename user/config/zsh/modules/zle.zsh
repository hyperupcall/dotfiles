source "$XDG_CONFIG_HOME/bash/modules/readline_util.sh"

_zle_x_discard() {
	_readline_util_x_discard "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_x_kill() {
	_readline_util_x_kill "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_x_yank() {
	_readline_util_x_yank "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_x_paste() {
	_readline_util_x_paste "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_show_help() {
	_readline_util_show_help "$BUFFER"
}

_zle_show_man() {
	_readline_util_show_man "$BUFFER"
}

_zle_show_tldr() {
	_readline_util_show_tldr "$BUFFER"
}

_zle_toggle_sudo() {
	_readline_util_toggle_sudo "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_toggle_backslash() {
	_readline_util_toggle_backslash "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_toggle_comment() {
	_readline_util_toggle_comment "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_trim_whitespace() {
	BUFFER="$(
		_readline_util_trim_whitespace "$BUFFER"
	)"
}

_zle_ls(){
	_shell_util_ls
}

_zle_exit() {
	exit
}

zle -N _zle_x_discard
zle -N _zle_x_kill
zle -N _zle_x_yank
zle -N _zle_x_paste
zle -N _zle_show_help
zle -N _zle_show_man
zle -N _zle_show_tldr
zle -N _zle_toggle_sudo
zle -N _zle_toggle_backslash
zle -N _zle_toggle_comment
zle -N _zle_trim_whitespace
zle -N _zle_ls
zle -N _zle_exit

bindkey -e "\eu" _zle_x_discard
bindkey -e "\ek" _zle_x_kill
bindkey -e "\ey" _zle_x_yank
bindkey -e "\eo" _zle_x_paste
bindkey -e "\eh" _zle_show_help
bindkey -e "\em" _zle_show_man
# bindkey -e "\et" _zle_show_tldr
bindkey -e "\es" _zle_toggle_sudo
bindkey -e "\e\\" _zle_toggle_backslash
bindkey -e "\e/" _zle_toggle_comment
bindkey -e "\C-_" _zle_toggle_comment
bindkey -e "\ei" _zle_trim_whitespace
bindkey -e "\el" _zle_ls
bindkey -e '^D' _zle_exit

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M vicmd '^T' history-incremental-pattern-search-backward # Patterned history search with zsh expansion, globbing, etc.
bindkey '^T' history-incremental-pattern-search-backward
bindkey -e
bindkey ' ' magic-space
bindkey -M isearch '^M' accept-search # Verify search result before accepting
