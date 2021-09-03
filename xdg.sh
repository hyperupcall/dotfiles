# shellcheck shell=bash

# @description XDG Base Directory locations differ based on operating
# systems. This file is read by ~/.dots/user/.config/dotty/deployments.all
# and other files
use_default_xdg() {
	export XDG_CONFIG_HOME="$HOME/.config"
	export XDG_STATE_HOME="$HOME/.local/state"
	export XDG_DATA_HOME="$HOME/.local/share"
	export XDG_CACHE_HOME="$HOME/.cache"
}

use_custom_xdg() {
	export XDG_CONFIG_HOME="$HOME/config"
	export XDG_STATE_HOME="$HOME/state"
	export XDG_DATA_HOME="$HOME/share"
	export XDG_CACHE_HOME="$HOME/.cache"
}

if [ -f /etc/os-release ]; then
	source /etc/os-release
else
	printf '%s\n' "Error: /etc/os-release not found. Exiting"
	exit 1
fi

case "$ID" in
	arch) use_custom_xdg ;;
	zorin) use_default_xdg ;;
	*) use_default_xdg ;;
esac
