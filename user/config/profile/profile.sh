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

. "$XDG_CONFIG_HOME/profile/misc.sh"

# ----------------------- Sourcing ----------------------- #
for d in aliases env fns fns-category; do
	for f in "$XDG_CONFIG_HOME/profile/$d"/?*.sh; do
		[ -r "$f" ] && . "$f"
	done
done
unset -v d f
