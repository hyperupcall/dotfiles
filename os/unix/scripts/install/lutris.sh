#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Lutris?'; then
		install.lutris
	fi
}

install.lutris() {
	apt_add_source 'lutris' 'deb [signed-by=/etc/apt/keyrings/lutris.gpg] https://download.opensuse.org/repositories/home:/strycore/Debian_12/ ./'
	wget -q -O- https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/keyrings/lutris.gpg > /dev/null

}

apt_add_source() {
	printf '% s\n' "$2" | sudo tee "/etc/apt/sources.list.d/$1.list" > /dev/null
}

main "$@"
