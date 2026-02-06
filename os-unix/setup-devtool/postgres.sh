#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='PostgreSQL'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	sudo apt-get install -y postgresql-common
	sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
	sudo apt-get update -y
	sudo apt-get install -y postgresql-17 postgresql-doc-17
}

installed() {
	[ -d /usr/lib/postgresql ]
}

util.if_file_sourced || _setup "$@"
