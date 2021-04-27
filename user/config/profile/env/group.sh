# shellcheck shell=sh

# bm
_path_prepend "$XDG_DATA_HOME/bm/bin"

# shell_installer
_path_prepend "$XDG_DATA_HOME/shell-installer/bin"
# TODO
# _path_prepend MANPATH "$XDG_DATA_HOME/shell-installer/man"

# fzf
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_DEFAULT_OPTS="--history \"$HOME/.history/fzf_history\" --history-size=10000"

# gcc
# export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# git
export GIT_CONFIG_NOSYSTEM=

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# guile
export GUILE_HISTORY="$HOME/.history/guile_history"

# hstr
export HSTR_CONFIG=hicolor

# less
# adding X breaks mouse scrolling of pages
export LESS="-FIRQ"
# export LESS="-FIRX" LESS="-M -I -R"
export LESS_ADVANCED_PREPROCESSOR=1 # lesspipe.sh
export LESSKEY="$XDG_CONFIG_HOME/less_keys"
export LESSOPEN="|$(command -v lesspipe.sh) %s"
export LESSHISTFILE="$HOME/.history/less_history"
export LESSHISTSIZE="32768"
export LESS_TERMCAP_mb="$(printf '\e[1;31m')" # start blink
export LESS_TERMCAP_md="$(printf '\e[1;36m')" # start bold
export LESS_TERMCAP_me="$(printf '\e[0m')" # end all
export LESS_TERMCAP_so="$(printf '\e[01;44;33m')" # start reverse video
export LESS_TERMCAP_se="$(printf '\e[0m')" # end reverse video
export LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
export LESS_TERMCAP_ue="$(printf '\e[0m')" # end underline
export LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline

# man
export MAN_POSIXLY_CORRECT= # openSUSE

# more
export MORE="-l"

# nnn
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# packer
export CHECKPOINT_DISABLE=1

# pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_CLIP_TIME="15"

# ps
export CMD_ENV="linux"

# ranger
export RANGER_LOAD_DEFAULT_RC="FALSE"

# qt
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || {
	export QT_QPA_PLATFORMTHEME="qt5ct"
}

# snapd
_path_append "/var/lib/snapd/snap/bin"

# sxhkd
export SXHKD_SHELL="$(command -v sh)"

# X11
export XCURSOR_PATH="$XDG_CONFIG_HOME/icons:$XCURSOR_PATH"

# zfs
export ZFS_COLOR=
