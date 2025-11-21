#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='MongoDB'

main() {
	util.install_by_setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/mongodb.asc"
	local dist='jammy'
	local version='8.0'

	pkg.add_apt_key \
		"https://pgp.mongodb.com/server-$version.asc" \
		"$gpg_file"

	pkg.add_apt_repository \
		"/etc/apt/sources.list.d/mongodb-$version.sources" "
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
	command -v &>/dev/null mongod
}

util.if_file_sourced || _setup "$@"
