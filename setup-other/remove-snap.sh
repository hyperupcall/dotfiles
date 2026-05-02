#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Remove Snap'

install.ubuntu() {
	for f in $(
		snap list | awk 'NR>1 {print $1}' # lint-ignore
	); do
		sudo snap remove "$f" # lint-ignore
	done

	sudo apt-get -y remove snapd
}

install.installed() {
	local snaps=
	snaps=$(command -v snap && snap list | awk 'NR>1 {print $1}') # lint-ignore

	[ -z "$snaps" ] && ! command -v snapd &>/dev/null
}

util.if_file_sourced || _setup "$@"
