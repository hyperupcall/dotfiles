# shellcheck shell=bash
if [ -n "$BASH_VERSION" ]; then
	shopt -s globstar
fi

# Source libraries.
source ~/.dotfiles/data/xdg.sh
for _f in \
	~/.dotfiles/vendor/bash-core/pkg/**/*.sh \
	~/.dotfiles/vendor/bash-term/pkg/**/*.sh; \
do
	source "$_f"
done; unset -v _f

GITHUB_TOKEN="$(<~/.dotfiles/.data/github_token)"

source ~/.dotfiles/vendor/setup.sh/setup.sh

if [ -z "$XDG_CONFIG_HOME" ]; then
	printf '%s\n' 'Failed because $XDG_CONFIG_HOME is empty' >&2
	exit 1
fi
if [ -z "$XDG_DATA_HOME" ]; then
	printf '%s\n' 'Failed because $XDG_DATA_HOME is empty' >&2
	exit 1
fi
if [ -z "$XDG_STATE_HOME" ]; then
	printf '%s\n' 'Failed because $XDG_STATE_HOME is empty' >&2
	exit 1
fi

CURL_CONFIG="$HOME/.dotfiles/data/curl_config.conf"

source ~/.dotfiles/data/setup-private.sh
