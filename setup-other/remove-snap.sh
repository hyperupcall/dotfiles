#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Remove Snap'

install.ubuntu() {
	for f in $(snap list | awk 'NR>1 {print $1}'); do
		sudo snap remove "$f"
	done

	# TODO: Should have a "cleanup" for distros that do this.
	if command -v snap &>/dev/null; then
		if snap info thunderbird &>/dev/null; then
			sudo snap remove thunderbird
		fi
	fi

	# TODO: Remove all snaps
	if command -v snap &>/dev/null; then
		if snap info firefox &>/dev/null; then
			sudo snap remove firefox
		fi
	fi
}

installed() {
	! command -v snapd &>/dev/null
}

util.if_file_sourced || _setup "$@"
