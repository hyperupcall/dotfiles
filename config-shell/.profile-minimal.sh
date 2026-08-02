# shellcheck shell=sh

_shell_original_path="$PATH"
. ~/.dotfiles/config/xdg.sh

# XDG base directory variables must exist.
if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ] || [ -z "$XDG_STATE_HOME" ] || [ -z "$XDG_CACHE_HOME" ]; then
	printf '%s\n' "Error: profile.sh: XDG base directory variables are not set. They should be set. Aborting source" >&2
	return 1
fi

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export MANPAGER='less'

_util_path_prepend "$HOME/.dotfiles/.data/bin"
_util_path_prepend "$HOME/.local/bin"
_util_source_file "$XDG_CONFIG_HOME/sh/aliases.sh"
_util_source_file "$XDG_CONFIG_HOME/sh/func.sh"
_util_source_file "$XDG_CONFIG_HOME/sh/func-override.sh"
if [ -z "${BASH_VERSION:-}" ] && [ -z "${ZSH_VERSION:-}" ] && [ -z "${KSH_VERSION:-}" ]; then
	_util_source_dir "$XDG_CONFIG_HOME/sh/shell.d"
fi
