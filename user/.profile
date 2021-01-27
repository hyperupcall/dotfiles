# shellcheck shell=sh
#
# ~/.profile
#

# ----------------------- Functions ---------------------- #
path_prepend() {
	[ -d "$1" ] || return

	# generalized path_prepend
	[ -n "$2" ] && {
		case ":$(eval "echo \$$1"):" in
			*":$2:"*) :;;
			*) eval "export $1=$2:$(eval "echo \$$1")" ;;
		esac
		return
	}

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$1:$PATH" ;;
	esac
}

path_append() {
	[ -d "$1" ] || return

	# generalized path_append
	[ -n "$2" ] && {
		case ":$(eval "echo \$$1"):" in
			*":$2:"*) :;;
			*) eval "export $1=$(eval "echo \$$1"):$2" ;;
		esac
		return
	}

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

path_prepend "$HOME/scripts"
path_prepend "$XDG_DATA_HOME/bm/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/Docs/pkg/app-image"

# ---------------------- Environment --------------------- #
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
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY QT_ACCESSIBILITY  XDG_CONFIG_HOME XDG_DATA_HOME XDG_RUNTIME_DIR
dbus-update-activation-environment --systemd

# --------------------- Miscellaneous -------------------- #
# overwrite readline unix-word-rubout with XOFF so readline forward-search-history (Control-s) isn't clobbered
stty stop '^W'

# ----------------------- Sourcing ----------------------- #
. "$XDG_CONFIG_HOME/profile/aliases.sh"
. "$XDG_CONFIG_HOME/profile/functions.sh"
. "$XDG_CONFIG_HOME/profile/groups.sh"
. "$XDG_CONFIG_HOME/profile/xdg.sh"

# ------------------------ Cleanup ----------------------- #
unset -f path_prepend
unset -f path_append
