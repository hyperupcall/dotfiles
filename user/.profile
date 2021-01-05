#
# ~/.profile
#

# ----------------------- Functions ---------------------- #
path_add_pre() {
	[ -d "$1" ] || return

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$1:$PATH" ;;
	esac
}

path_add_post() {
	[ -d "$1" ] || return

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$PATH:$1" ;;
	esac
}

# ------------------------ Common ------------------------ #
umask 022

export XDG_DATA_HOME="$HOME/data"
export XDG_CONFIG_HOME="$HOME/config"
export XDG_CACHE_HOME="$HOME/.cache"

export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="$LANG"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export VISUAL="vim"
export EDITOR="$VISUAL"
export DIFFPROG="vim -d"
export PAGER="less"
export MANPAGER="less -X"
export BROWSER="brave"
export SPELL="aspell -x -c"
export CMD_ENV="linux" # ps
export MAN_POSIXLY_CORRECT= # openSUSE
export XCURSOR_PATH="$XDG_CONFIG_HOME/icons:$XCURSOR_PATH"
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK

path_add_pre "$HOME/scripts"
path_add_pre "$HOME/data/bm/bin"
path_add_pre "$HOME/.local/bin"
path_add_pre "$HOME/bin"
path_add_pre "$HOME/Docs/pkg/app-image"



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


# tell dbus-daemon --session (and systemd --user, if running) some x environment variables
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
dbus-update-activation-environment --systemd QT_ACCESSIBILITY

# systemctl --user import-environment XDG_CONFIG_HOME
# systemctl --user import-environment XDG_DATA_HOME
# systemctl --user import-environment XDG_RUNTIME_DIR

. "$XDG_CONFIG_HOME/profile/aliases.sh"
. "$XDG_CONFIG_HOME/profile/functions.sh"
. "$XDG_CONFIG_HOME/profile/groups.sh"
. "$XDG_CONFIG_HOME/profile/xdg.sh"

# ---------------------------------- Cleanup --------------------------------- #
unset -f path_add_pre
unset -f path_add_post
