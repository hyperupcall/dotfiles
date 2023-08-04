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


# ({
# 	if [ -z "$XDG_RUNTIME_DIR" ]; then
# 		# If 'XDG_RUNTIME_DIR' is not set, then most likely dbus has not started, which means
# 		# the following commands will not work. This can occur in WSL environments, for example
# 		exit
# 	fi

# 	dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# 	printenv -0 \
# 	| awk '
# 		BEGIN {
# 			RS="\0"
# 			FS="="
# 		}
# 		{
# 			if($1 ~ /^LESS_TERMCAP/) { next }
# 			if($1 ~ /^TIMEFORMAT$/) { next }
# 			if($1 ~ /^_$/) { next }

# 			printf "%s\0", $1
# 		}' \
# 	| xargs -0 systemctl --user import-environment
# } &)

autoload run-help
autoload zmv
# autoload -Uz edit-command-line run-help zmv
# autoload -Uz add-zsh-hook

autoload -RU colors && colors
autoload -RUz run-help
autoload -RUz run-help-git
autoload -RUz run-help-svn
autoload -RUz run-help-svk
# autoload -RUz promptinit
# promptinit

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
# key[Control-Left]="${terminfo[kLFT5]}"
# key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
