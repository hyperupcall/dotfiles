#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='pgAdmin'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	local gpg_file='/etc/apt/keyrings/pgadmin.asc'

	pkg.add_apt_key 'https://www.pgadmin.org/static/packages_pgadmin_org.pub' \
		"$gpg_file"

	pkg.add_apt_repository \
	'/etc/apt/sources.list.d/pgadmin4.sources' \
		"Types: deb
URIs: https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/noble
Suites: pgadmin4
Components: main
Signed-By: /etc/apt/keyrings/pgadmin.asc"

	sudo apt-get update -y
	sudo apt-get install -y pgadmin4-desktop
}

installed() {
	[ -d /usr/pgadmin4 ]
}

util.if_file_sourced || _setup "$@"
