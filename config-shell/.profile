# shellcheck shell=sh

_shell_original_path="$PATH"
umask 022
. ~/.dotfiles/config/xdg.sh

# XDG base directory variables must exist.
if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ] || [ -z "$XDG_STATE_HOME" ] || [ -z "$XDG_CACHE_HOME" ]; then
	printf '%s\n' "Error: profile.sh: XDG base directory variables are not set. They should be set. Aborting source" >&2
	return 1
fi

# Set tty settings.
# Surpress 'inappropriate ioctl for device' errors on some distros.
if [ -t 0 ]; then
	# Special characters.
	stty discard undef
	stty start undef
	stty stop undef
	# Input settings.
	stty -ixoff
	stty -ixon
fi

# Set options.
set +o noclobber
set -o notify

# Add custom functions and PATH.
. "$XDG_CONFIG_HOME/sh/util.sh"
_util_path_prepend "$HOME/.dotfiles/.data/bin"
_util_path_prepend "$HOME/.local/bin"
_util_path_prepend "$XDG_STATE_HOME/pipx/bin"
_util_source_file "$XDG_CONFIG_HOME/sh/aliases.sh"
_util_source_file "$XDG_CONFIG_HOME/sh/env.sh"
_util_source_file "$XDG_CONFIG_HOME/sh/func.sh"
_util_source_file "$XDG_CONFIG_HOME/sh/func-override.sh"
if [ -z "${BASH_VERSION:-}" ] && [ -z "${ZSH_VERSION:-}" ] && [ -z "${KSH_VERSION:-}" ]; then
	_util_source_dir "$XDG_CONFIG_HOME/sh/shell.d"
fi
# ---
