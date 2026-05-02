#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='Lutris'
declare -g g_sources_file='/etc/apt/sources.list.d/lutris.sources'

install.debian() {
	local gpg_file="/etc/apt/keyrings/lutris.asc"

	pkg.add_apt_key \
		'https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://download.opensuse.org/repositories/home:/strycore/Debian_12/
			Suites: ./
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"
}

install.ubuntu() {
	util.get_latest_github_release 'lutris/lutris'
	local version="$REPLY"
	version=${version#v}

	curl -K "$CURL_CONFIG" -o 'lutris.deb' "https://github.com/lutris/lutris/releases/download/v${version}/lutris_${version}_all.deb"
	sudo apt-get install -y './lutris.deb'
}

install.fedora() {
	sudo dnf install -y lutris
}

install.opensuse() {
	sudo zypper -n install lutris
}

install.arch() {
	sudo pacman -Syu --noconfirm lutris
}

install.installed() {
	[ -f "$g_sources_file" ] && command -v lutris &>/dev/null
}

util.if_file_sourced || _setup "$@"
