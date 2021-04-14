#
# ~/.zshrc
#

[ -r "$XDG_CONFIG_HOME/zsh/.zprofile" ] && source "$XDG_CONFIG_HOME/zsh/.zprofile"

[[ $- != *i* ]] && [ ! -t 0 ] && return

# -------------------- Shell Variables ------------------- #
setopt auto_cd
unsetopt auto_pushd
unsetopt cdable_vars
unsetopt cd_silent
setopt chase_dots
setopt chase_links
setopt posix_cd
unsetopt pushd_ignore_dups
unsetopt pushd_silent
unsetopt complete_aliases
setopt glob_complete
unsetopt hist_beep

unalias run-help
autoload run-help

autoload zmv

autoload -U compinit
compinit -d "$XDG_DATA_DIR/zsh/zcompdump"

# export SDKMAN_DIR="/home/edwin/data/sdkman"
# [[ -s "/home/edwin/data/sdkman/bin/sdkman-init.sh" ]] && source "/home/edwin/data/sdkman/bin/sdkman-init.sh"
# eval "$(direnv hook zsh)"

# source /home/edwin/.config/broot/launcher/bash/br
# >>>> Vagrant command completion (start)

# fpath=(/tmp/.mount_vagranZ1pbC8/usr/gembundle/gems/vagrant-2.2.13/contrib/zsh $fpath)
# compinit
# # <<<<  Vagrant command completion (end)

# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /home/edwin/data/bm/bin/terraform terraform
# [[ -s "$HOME/data/rvm/scripts/rvm" ]] && source "$HOME/data/rvm/scripts/rvm" # Load RVM into a shell session *as a function*
bindkey -e

eval "$(starship init zsh)"
bindkey -M menuselect '^M' .accept-line
alias assumed="git ls-files -v | grep ^h | sed -e 's/^h\ //'"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

HELPDIR=/usr/share/zsh/$ZSH_VERSION/help

PROMPT='${SSH_CONNECTION+%m }%n $vimode ${repo:+$repo }%F{cyan}%~%f '

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -Uz edit-command-line run-help compinit zmv
zmodload zsh/complist
compinit

zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select

setopt auto_cd \
    glob_dots \
    extended_glob \
    prompt_subst \
    rm_star_silent \
    print_exit_value \
    complete_aliases \
    numeric_glob_sort \
    hist_verify \
    hist_append \
    hist_fcntl_lock \
    hist_save_no_dups \
    hist_ignore_space \
    hist_ignore_all_dups \
    share_history \
    inc_append_history \
    interactive_comments

# This is the behaviour of the shell without disabling multios:
#   % { print stdout; print stderr >&2; } 2>&1 > /dev/null | xargs
#   stderr stdout
unsetopt multios

READNULLCMD=$PAGER

function precmd {
    # Print basic prompt to the window title.
    print -Pn "\e];%n %~\a"

    case $(git rev-parse --is-bare-repository 2> /dev/null) in
        false) repo=%F{green}${"$(git rev-parse --show-toplevel)":t}%f ;;
        true)  repo=%F{blue}${"$(git rev-parse --git-dir)":P:t}%f ;;
        *)     repo=
    esac
}

# Print the current running command's name to the window title.
function preexec {
    printf '\e]2;%s\a' "$1"
}

# Replace vimode indicators.
function zle-line-init zle-keymap-select {
    vimode=${${KEYMAP/vicmd/c}/main/i}
    zle reset-prompt
}

# Prompting.
setopt PROMPT_CR
setopt PROMPT_SP

# History.
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Directory.
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

bindkey -v

# Initialise vimode to insert mode.
vimode=i

# Remove the default 0.4s ESC delay, set it to 0.1s.
KEYTIMEOUT=1

# Shift-tab.
bindkey $terminfo[kcbt] reverse-menu-complete

# Delete.
bindkey -M vicmd $terminfo[kdch1] vi-delete-char
bindkey          $terminfo[kdch1] delete-char

# Insert.
bindkey -M vicmd $terminfo[kich1] vi-insert
bindkey          $terminfo[kich1] overwrite-mode

# Home.
bindkey -M vicmd $terminfo[khome] vi-beginning-of-line
bindkey          $terminfo[khome] vi-beginning-of-line

# End.
bindkey -M vicmd $terminfo[kend] vi-end-of-line
bindkey          $terminfo[kend] vi-end-of-line

# Backspace (and <C-h>).
bindkey -M vicmd $terminfo[kbs] backward-char
bindkey          $terminfo[kbs] backward-delete-char

# Page up (and <C-b> in vicmd).
bindkey -M vicmd $terminfo[kpp] beginning-of-buffer-or-history
bindkey          $terminfo[kpp] beginning-of-buffer-or-history

# Page down (and <C-f> in vicmd).
bindkey -M vicmd $terminfo[knp] end-of-buffer-or-history
bindkey          $terminfo[knp] end-of-buffer-or-history

bindkey -M vicmd '^B' beginning-of-buffer-or-history

# Do history expansion on space.
bindkey ' ' magic-space

# Use M-w for small words.
bindkey '^[w' backward-kill-word
bindkey '^W' vi-backward-kill-word

bindkey -M vicmd '^H' backward-char
bindkey          '^H' backward-delete-char

# h and l whichwrap.
bindkey -M vicmd 'h' backward-char
bindkey -M vicmd 'l' forward-char

# Incremental undo and redo.
bindkey -M vicmd '^R' redo
bindkey -M vicmd 'u' undo

# Misc.
bindkey -M vicmd 'ga' what-cursor-position

# Open in editor.
bindkey -M vicmd 'v' edit-command-line

# History search.
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Patterned history search with zsh expansion, globbing, etc.
bindkey -M vicmd '^T' history-incremental-pattern-search-backward
bindkey          '^T' history-incremental-pattern-search-backward

# Verify search result before accepting.
bindkey -M isearch '^M' accept-search

alias help='run-help'
