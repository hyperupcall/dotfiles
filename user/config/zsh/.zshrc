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
