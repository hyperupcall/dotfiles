# shellcheck shell=sh

#
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && [ -n "$XDG_RUNTIME_DIR" ] && \
		[ "$XDG_RUNTIME_DIR" = "/run/user/$(id -u)" ] && \
		[ -S "$XDG_RUNTIME_DIR/bus" ]; then
	# We are under systemd-logind or something remarkably similar, and
	# a user-session socket has already been set up.
	#
	# Be nice to non-libdbus, non-sd-bus implementations by using
	# that as the session bus address in the environment. The check for
	# XDG_RUNTIME_DIR = "/run/user/`id -u`" is because we know that
	# form of the address, from systemd-logind, doesn't need escaping,
	# whereas arbitrary addresses might.
	DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
	export DBUS_SESSION_BUS_ADDRESS
fi
# tell dbus-daemon --session (and systemd --user, if running) some environment variables
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY QT_ACCESSIBILITY XDG_CONFIG_HOME XDG_DATA_HOME XDG_RUNTIME_DIR
dbus-update-activation-environment --systemd

# bm
_path_prepend "$XDG_DATA_HOME/bm/bin"

# shell_installer
_path_prepend "$XDG_DATA_HOME/shell-installer/bin"
_path_prepend MANPATH "$XDG_DATA_HOME/shell-installer/man"

# fzf
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_DEFAULT_OPTS="--history \"$HOME/.history/fzf_history\" --history-size=10000"

# gcc
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# git
export GIT_CONFIG_NOSYSTEM=

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
GPG_TTY="$(tty)"
export GPG_TTY
SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK

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

# man
export MAN_POSIXLY_CORRECT= # openSUSE

# more
export MORE="-l"

# nnn
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# ps
export CMD_ENV="linux"

# ranger
export RANGER_LOAD_DEFAULT_RC="FALSE"

# qt
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] \
	|| export QT_QPA_PLATFORMTHEME="qt5ct"

# snap
_path_append "/var/lib/snapd/snap/bin"

# X11
export XCURSOR_PATH="$XDG_CONFIG_HOME/icons:$XCURSOR_PATH"

# zfs
export ZFS_COLOR=
