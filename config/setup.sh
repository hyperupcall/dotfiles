# shellcheck shell=bash
if [ -n "${BASH_VERSION:-}" ]; then
	shopt -s globstar
fi

# Source libraries.
source ~/.dotfiles/config/xdg.sh
for _f in \
	~/.dotfiles/vendor/bash-core/pkg/**/*.sh \
	~/.dotfiles/vendor/bash-term/pkg/**/*.sh; do
	source "$_f"
done
unset -v _f

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

CURL_CONFIG="$HOME/.dotfiles/config/curl_config.conf"

source ~/.dotfiles/config/setup-private.sh

util.is_in_container_or_chroot() {
	core.print_warn 'Detecting if running in a container or chroot.'
	if command -v systemd-detect-virt &>/dev/null; then
		systemd-detect-virt --quiet --container --chroot
	else
		local stat1= stat2=
		stat1=$(stat -c %i /)
		stat2=$(stat -c %i /proc/1/root)

		[ -e /.dockerenv ] && ((stat1 != stat2))
	fi
}
