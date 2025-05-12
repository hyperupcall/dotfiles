# shellcheck shell=sh

_shell_original_path="$PATH"
umask 022
. ~/.dotfiles/os-unix/data/xdg.sh

# XDG base directory variables (either from PAM or `xdg.sh`) must exist.
if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ] || [ -z "$XDG_STATE_HOME" ] || [ -z "$XDG_CACHE_HOME" ]; then
	printf '%s\n' "Error: profile.sh: XDG base directory variables are not set. They should have been set by PAM. Aborting source" >&2
	return 1
fi

# Set tty settings.
if [ -t 0 ]; then # Surpress 'inappropriate ioctl for device' errors on some distros.
	# Special characters.
	stty discard undef
	stty start undef
	stty stop undef
	# Input settings.
	stty -ixoff
	stty -ixon
fi

source "$XDG_CONFIG_HOME/sh/util.sh"
_util_path_prepend "$HOME/.dotfiles/.data/bin"
_util_path_prepend "$HOME/.local/bin"
_util_path_prepend "$XDG_STATE_HOME/pipx/bin"

# Source other shell configuration files.
for f in "$XDG_CONFIG_HOME/sh/modules"/*.sh; do
	[ -r "$f" ] && . "$f"
done
unset -v f

# ---
