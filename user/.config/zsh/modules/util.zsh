# TODO: zcompile
# autoload -Uz zcompile

# zmodload zsh/attr
# zmodload zsh/cap
# zmodload zsh/clone
zmodload zsh/compctl
zmodload zsh/complete
zmodload zsh/complist
zmodload zsh/computil
# zmodload zsh/curses
# zmodload zsh/datetime
# zmodload zsh/db/gdbm
# zmodload zsh/deltochar
# zmodload zsh/files
# zmodload zsh/langinfo
# zmodload zsh/mapfile
# zmodload zsh/mathfunc
# zmodload zsh/nearcolor
# zmodload zsh/newuser
# zmodload zsh/parameter
# zmodload zsh/pcre
# zmodload zsh/param/private
# zmodload zsh/regex
# zmodload zsh/sched
# zmodload zsh/net/socket
# zmodload zsh/stat
# zmodload zsh/system
# zmodload zsh/net/tcp
# zmodload zsh/termcap
# zmodload zsh/terminfo
# zmodload zsh/zftp
zmodload zsh/zle
zmodload zsh/zleparameter
# zmodload zsh/zprof
zmodload zsh/zpty
# zmodload zsh/zselelct
# zmodload zsh/util

typeset -U PATH path
# path=("$HOME/.local/bin" /other/things/in/path "$path[@]")

# TODO: compdump
autoload run-help
autoload zmv
autoload -Uz compinit
compinit
autoload -Uz edit-command-line run-help compinit zmv
autoload -Uz add-zsh-hook

autoload -RU colors && colors
autoload -RUz run-help
autoload -RUz run-help-git
autoload -RUz run-help-svn
autoload -RUz run-help-svk
autoload -RUz compinit promptinit
compinit
promptinit

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
# key[Control-Left]="${terminfo[kLFT5]}"
# key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

compinit

function zle-line-init zle-keymap-select {
	vimode=${${KEYMAP/vicmd/c}/main/i}
	zle reset-prompt
}
