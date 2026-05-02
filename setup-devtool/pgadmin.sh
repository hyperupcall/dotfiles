#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='pgAdmin'
declare -g g_sources_file='/etc/apt/sources.list.d/pgadmin4.sources'

install.ubuntu() {
	local gpg_file='/etc/apt/keyrings/pgadmin.asc'

	pkg.add_apt_key 'https://www.pgadmin.org/static/packages_pgadmin_org.pub' \
		"$gpg_file"

	pkg.add_apt_repository \
		"$g_sources_file" "
		Types: deb
		URIs: https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release --short --codename)
		Suites: pgadmin4
		Components: main
		Architectures: $(dpkg --print-architecture)
		signed-by: $gpg_file"

	sudo apt-get update -y
	sudo apt-get install -y pgadmin4-desktop
}

install.installed() {
	[ -f "$g_sources_file" ] && [ -d /usr/pgadmin4 ]
}

util.if_file_sourced || _setup "$@"
