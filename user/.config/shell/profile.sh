# shellcheck shell=sh

# ------------------------- Basic ------------------------ #
return

umask 022

set -- # TODO: This shouldn't be necessary (something to do with Kitty?)
. ~/.dots/xdg.sh

# XDG variables should have been read by PAM from ~/.pam_environment
if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ] || [ -z "$XDG_STATE_HOME" ] || [ -z "$XDG_CACHE_HOME" ]; then
	printf '%s\n' "Error: XDG Base Directory variables are not set. They should have been set by PAM" >&2
	return 1
fi

return

. "$XDG_CONFIG_HOME/shell/modules/util.sh"
. "$XDG_CONFIG_HOME/shell/modules/env.sh"
. "$XDG_CONFIG_HOME/shell/modules/xdg.sh"

_path_prepend "$HOME/.dots/bootstrap/dotmgr/bin"
_path_prepend "$HOME/.dots/.bin"
_path_prepend "$HOME/.local/bin"

if [ -t 0 ]; then # Required due to 'inappropriate ioctl for device' errors on some distros
	stty discard undef # special characters
	stty start undef
	stty stop undef
	stty -ixoff # input settings
	stty -ixon
fi

# ----------------------- Sourcing ----------------------- #
for d in aliases functions; do
	for f in "$XDG_CONFIG_HOME/shell/modules/$d"/*.sh; do
		[ -r "$f" ] && . "$f"
	done
done
unset -v d f

# ---------------------- Environment --------------------- #
# . "$XDG_CONFIG_HOME/shell/generated/aggregated.sh" # FIXME

({
	if [ -z "$XDG_RUNTIME_DIR" ]; then
		# If 'XDG_RUNTIME_DIR' is not set, then most likely dbus has not started, which means
		# the following commands will not work. This can occur in WSL environments, for example
		exit
	fi

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
