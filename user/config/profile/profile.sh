# shellcheck shell=sh

# ------------------------- Basic ------------------------ #
umask 022

export XDG_DATA_HOME="$HOME/data"
export XDG_CONFIG_HOME="$HOME/config"
export XDG_CACHE_HOME="$HOME/.cache"

. "$XDG_CONFIG_HOME/profile/util.sh"

_path_prepend "$HOME/scripts"
_path_prepend "$HOME/.local/bin"
_path_prepend "$HOME/Docs/pkg/app-image"

. "$XDG_CONFIG_HOME/profile/xdg.sh"


# ----------------------- Sourcing ----------------------- #
for d in aliases env fns fns-category; do
	for f in "$XDG_CONFIG_HOME/profile/$d"/?*.sh; do
		[ -r "$f" ] && . "$f"
	done
done
unset -v d f


# Session / User
# https://salsa.debian.org/utopia-team/dbus/blob/debian/master/debian/20dbus_xdg-runtime
# https://githubj.com/systemd/systemd/commit/2b2b7228bffef626fe8e9f131095995f3d50ee3b
# [ "$XDG_RUNTIME_DIR" = "/run/user/$(id -u)" ] && [ -S "$XDG_RUNTIME_DIR/bus" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && {
# 	# We are under systemd-logind or something remarkably similar, and
# 	# a user-session socket has already been set up.

# 	# Be nice to non-libdbus, non-sd-bus implementations by using
# 	# that as the session bus address in the environment. The check for
# 	# XDG_RUNTIME_DIR = "/run/user/`id -u`" is because we know that
# 	# form of the address, from systemd-logind, doesn't need escaping,
# 	# whereas arbitrary addresses might.
# 	export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
# }

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY QT_ACCESSIBILITY

# TODO: are these needed
dbus-update-activation-environment --systemd XDG_CONFIG_HOME XDG_DATA_HOME XDG_RUNTIME_DIR

(
	envVars="$(printenv --null | awk '
		BEGIN {
			RS="\0"
			FS="="
		}
		{
			if($1 ~ /^LESS_TERMCAP/) { next }
			if($1 ~ /^_$/) { next }

			printf "%s ", $1
		}
	')"

	# shellcheck disable=SC2086
	systemctl --user import-environment $envVars &
)
