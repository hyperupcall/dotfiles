#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Juno Computers Drivers'

install.ubuntu() {
	sudo apt-get install -y software-properties-common ca-certificates

	sudo add-apt-repository -y ppa:junocomp/juno-apps
	sudo apt-get update -y
	sudo apt-get install -y juno-installer

	juno-installer

	sudo chown "$USER:$USER" "$XDG_DATA_HOME/share/icons"
}

installed() {
	command -v juno-installer &>/dev/null
}

util.if_file_sourced || _setup "$@"
