# shellcheck shell=sh

# bm
export BM_SRC="$HOME/Docs/Programming/repos/bm"
alias bm='~/repos/bm/bm.sh'
path_add_pre "$XDG_DATA_HOME/bm/bin"

# git
export GIT_CONFIG_NOSYSTEM=

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
GPG_TTY="$(tty)"
export GPG_TTY

# hstr
export HSTR_CONFIG=hicolor

# less
# adding X breaks mouse scrolling of pages
export LESS="-FIRQ"
# export LESS="-FIRX" LESS="-M -I -R"
export LESSKEY="$XDG_CONFIG_HOME/less_keys"
export LESSHISTFILE="$HOME/.history/less_history"
export LESSHISTSIZE="32768"
LESS_TERMCAP_mb="$(printf '\e[1;31m')" # start blink
LESS_TERMCAP_md="$(printf '\e[1;36m')" # start bold
LESS_TERMCAP_me="$(printf '\e[0m')" # end all
LESS_TERMCAP_so="$(printf '\e[01;44;33m')" # start reverse video
LESS_TERMCAP_se="$(printf '\e[0m')" # end reverse video
LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
LESS_TERMCAP_ue="$(printf '\e[0m')" # end underline
LESS_TERMCAP_us="$(printf '\e[1;32m')" # start underline
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me \
	LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us \
	LESS_TERMCAP_ue LESS_TERMCAP_us

# more
export MORE="-l"

# nnn
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# qt
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] \
	|| export QT_QPA_PLATFORMTHEME="qt5ct"

# snap
#export PATH="/snap/bin:$PATH"
path_add_post "/var/lib/snapd/snap/bin"

# zfs
export ZFS_COLOR=
