#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Steam'

install.debian() {
	curl -K "$CURL_CONFIG" -o ./steam.deb 'https://cdn.akamai.steamstatic.com/client/installer/steam.deb'
	# With `apt-get install`, it might automatically choose 'steam-launcher' from repository.
	sudo dpkg -i ./steam.deb
}

install.opensuse() {
	flatpak install -y --user 'https://flathub.org/repo/appstream/com.valvesoftware.Steam.flatpakref'
	sudo zypper -n install steam-devices
}

installed() {
	command -v steam &>/dev/null
}

util.if_file_sourced || _setup "$@"
