# shellcheck shell=sh

# ------------------------- Basic ------------------------ #

umask 022

. ~/.dotfiles/xdg.sh

# XDG variables should have been read by PAM from ~/.pam_environment
if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ] || [ -z "$XDG_STATE_HOME" ] || [ -z "$XDG_CACHE_HOME" ]; then
	printf '%s\n' "Error: profile.sh: XDG Base Directory variables are not set. They should have been set by PAM. Aborting source" >&2
	return 1
fi

if [ -t 0 ]; then # Surpress 'inappropriate ioctl for device' errors on some distros
	stty discard undef # special characters
	stty start undef
	stty stop undef
	stty -ixoff # input settings
	stty -ixon
fi


# ----------------------- Sourcing ----------------------- #
. "$XDG_CONFIG_HOME/shell/modules/util.sh"

_path_prepend "$HOME/.dotfiles/.data/bin"
_path_prepend "$HOME/.local/bin"

. "$XDG_CONFIG_HOME/shell/modules/env.sh"
. "$XDG_CONFIG_HOME/shell/modules/xdg.sh"
for d in aliases functions; do
	for f in "$XDG_CONFIG_HOME/shell/modules/$d"/*.sh; do
		[ -r "$f" ] && . "$f"
	done; unset -v f
done; unset -v d

# ---
