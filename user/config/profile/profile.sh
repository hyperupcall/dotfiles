# shellcheck shell=sh

# ------------------------- Basic ------------------------ #
umask 022

export XDG_DATA_HOME="$HOME/data"
export XDG_CONFIG_HOME="$HOME/config"
export XDG_CACHE_HOME="$HOME/.cache"

. "$XDG_CONFIG_HOME/profile/util.sh"
. "$XDG_CONFIG_HOME/profile/xdg.sh"

_path_prepend "$HOME/scripts"
_path_prepend "$HOME/.local/bin"
_path_prepend "$HOME/Docs/pkg/app-image"

stty discard undef # special characters
stty start undef
stty stop undef
stty -ixoff # input settings
stty -ixon

# ----------------------- Sourcing ----------------------- #
for d in aliases env fns fns-category; do
	for f in "$XDG_CONFIG_HOME/profile/$d"/?*.sh; do
		[ -r "$f" ] && . "$f"
	done
done
unset -v d f

# ---------------------- Environment --------------------- #
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

({
	printenv -0 \
	| awk '
		BEGIN {
			RS="\0"
			FS="="
		}
		{
			if($1 ~ /^LESS_TERMCAP/) { next }
			if($1 ~ /^_$/) { next }

			printf "%s\0", $1
		}' \
	| xargs -0 systemctl --user import-environment
} &)
