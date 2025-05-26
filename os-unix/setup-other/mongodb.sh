#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='MongoDB'

main() {
	helper.setup "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/mongodb.asc"
	local dist='jammy'

	pkg.add_apt_key \
		'https://www.mongodb.org/static/pgp/server-6.0.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		'/etc/apt/sources.list.d/mongodb-6.0.sources' "
			Types: deb
			URIs: https://repo.mongodb.org/apt/ubuntu
			Suites: $dist/mongodb-org/6.0
			Components: multiverse
			Architectures: $(dpkg --print-architecture)
			signed-by: $gpg_file"

	sudo apt-get -y update
	sudo apt-get install -y mongodb-org
}

util.if_file_sourced || helper.run_main "$@"
