# shellcheck shell=bash
# Source libraries.
source ~/.dotfiles/os-unix/data/xdg.sh
for _f in \
	~/.dotfiles/vendor/bash-core/pkg/**/*.sh \
	~/.dotfiles/vendor/bash-term/pkg/**/*.sh; \
do
	source "$_f"
done; unset -v _f

GITHUB_TOKEN="$(<~/.dotfiles/.data/github_token)"
CURL_CONFIG="$HOME/.dotfiles/os-unix/data/curl_config.conf"

source ~/.dotfiles/vendor/setup.sh/setup.sh
