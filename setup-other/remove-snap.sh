#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Remove Snap'

install.ubuntu() {
	if command -v snap &>/dev/null; then
		# When no snaps are installed, `snap list` prints a message to stderr and
		# exits non-zero, so discard stderr and iterate directly over parsed names.
		for f in $(
			snap list 2>/dev/null | awk 'NR>1 {print $1}' # lint-ignore
		); do
			sudo snap remove "$f" || : # lint-ignore
		done

		sudo apt-get -y remove snapd
	fi

	rm -rf ~/snap
	sudo rm -rf /snap
}

install.installed() {
	! command -v snap &>/dev/null
}

util.if_file_sourced || _setup "$@"
