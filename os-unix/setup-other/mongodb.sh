#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='MongoDB'
declare -g g_sources_file='/etc/apt/sources.list.d/mongodb-8.2.sources'

install.debian() {
	local gpg_file="/etc/apt/keyrings/mongodb.asc"
	local dist=
	dist=$(lsb_release --codename --short)
	local version='8.2'

	pkg.add_apt_key \
		"https://pgp.mongodb.com/server-$version.asc" \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
			Types: deb
			URIs: https://repo.mongodb.org/apt/ubuntu
			Suites: $dist/mongodb-org/$version
			Components: multiverse
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get install -y mongodb-org
}

install.ubuntu() {
	install.debian "$@"
}

installed() {
	[ -f "$g_sources_file" ] && command -v mongod &>/dev/null
}

util.if_file_sourced || _setup "$@"
