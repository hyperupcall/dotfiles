# shellcheck shell=sh

# ------------------------- Basic ------------------------ #
umask 022

. ~/.dots/xdg.sh

# XDG variables should have been read by PAM from ~/.pam_environment
if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ] || [ -z "$XDG_STATE_HOME" ] || [ -z "$XDG_CACHE_HOME" ]; then
	printf '%s\n' "Error: XDG Base Directory variables are not set. They should have been set by PAM"
fi

. "$XDG_CONFIG_HOME/shell/modules/util.sh"
. "$XDG_CONFIG_HOME/shell/modules/env.sh"
. "$XDG_CONFIG_HOME/shell/modules/xdg.sh"

_path_prepend "$HOME/scripts"
_path_prepend "$HOME/.local/bin"
_path_prepend "$HOME/Docs/pkg/app-image"

# TODO
#stty discard undef # special characters
#stty start undef
#stty stop undef
#stty -ixoff # input settings
#stty -ixon

# TODO: setterm

# ----------------------- Sourcing ----------------------- #
for d in aliases functions; do
	for f in "$XDG_CONFIG_HOME/shell/modules/$d"/?*.sh; do
		[ -r "$f" ] && . "$f"
	done
done
unset -v d f

# ---------------------- Environment --------------------- #
#. "$XDG_CONFIG_HOME/shell/generated/aggregated.sh" # TODO

({
	dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

	printenv -0 \
	| awk '
		BEGIN {
			RS="\0"
			FS="="
		}
		{
			if($1 ~ /^LESS_TERMCAP/) { next }
			if($1 ~ /^TIMEFORMAT$/) { next }
			if($1 ~ /^_$/) { next }

			printf "%s\0", $1
		}' \
	| xargs -0 systemctl --user import-environment
} &)

# ---
