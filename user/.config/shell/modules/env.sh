# shellcheck shell=sh

# ------------------------ General ----------------------- #
export NAME="Edwin Kofler"
export EMAIL="edwin@kofler.com"

export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-"$LANG"}"
export LC_ALL="${LC_ALL:-"$LANG"}"
export VISUAL="nvim"
export EDITOR="$VISUAL"
export DIFFPROG="vim -d"
export PAGER="less"
# export BROWSER="brave-browser"
# export SPELL="aspell -x -c"


# ------------------------ Program ----------------------- #
# fzf
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_DEFAULT_OPTS="--history \"$XDG_STATE_HOME/history/fzf_history\" --history-size=10000"

# gnupg
export GPG_TTY=$(tty)

# guile
export GUILE_HISTORY="$XDG_STATE_HOME/history/guile_history"

# hstr
export HSTR_CONFIG='hicolor'

# less
export LESS='-FRQ' # Common Flags: -F,-I,-M,-R,-Q
# export LESS_ADVANCED_PREPROCESSOR=1 # lesspipe.sh
export LESSKEY="$XDG_CONFIG_HOME/less/less_keys"
# export LESSOPEN="|source-highlight-esc.sh %s"
export LESSHISTFILE="$XDG_STATE_HOME/history/less_history"
export LESSHISTSIZE='32768'
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || [ -n "$KSH_VERSION" ]; then
	export LESS_TERMCAP_mb=$'\e[1;31m' # start blink
	export LESS_TERMCAP_md=$'\e[1;36m' # start bold
	export LESS_TERMCAP_me=$'\e[0m' # end all
	export LESS_TERMCAP_so=$'\e[01;44;33m' # start reverse video
	export LESS_TERMCAP_se=$'\e[0m' # end reverse video
	export LESS_TERMCAP_us=$'\e[1;32m' # start underline
	export LESS_TERMCAP_ue=$'\e[0m' # end underline
	export LESS_TERMCAP_us=$'\e[1;32m' # start underline
else
	export LESS_TERMCAP_mb="$(printf '\e[1;31m')" # start blink
	export LESS_TERMCAP_md="$(printf '\e[1;36m')" # start bold
	export LESS_TERMCAP_me="$(printf '\e[0m')" # end all
	export LESS_TERMCAP_so="$(printf '\e[01;44;33m')" # start reverse video
	export LESS_TERMCAP_se="$(printf '\e[0m')" # end reverse video
	export LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
	export LESS_TERMCAP_ue="$(printf '\e[0m')" # end underline
	export LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
fi

# man
export MAN_POSIXLY_CORRECT= # openSUSE # TODO

# more
export MORE='-l'

# nnn
export NNN_FALLBACK_OPENER='xdg-open'
export NNN_DE_FILE_MANAGER='nautilus'

# packer
export CHECKPOINT_DISABLE='1'

# pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_CLIP_TIME='15'

# ps
export CMD_ENV='linux'

# qt
export QT_ACCESSIBILITY='1'

# ranger
export RANGER_LOAD_DEFAULT_RC='FALSE'

# qt
# [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || {
# 	export QT_QPA_PLATFORMTHEME="qt5ct"
# }

# snapd
_path_append '/var/lib/snapd/snap/bin'

# ssh
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK=
  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# sxhkd
export SXHKD_SHELL='/bin/sh'

# X11
export XCURSOR_PATH="$XDG_CONFIG_HOME/icons:$XCURSOR_PATH"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# zfs
export ZFS_COLOR=
